import 'package:cookit/data/models/filter_state.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/services/recipe_service.dart';
import 'package:cookit/data/services/recommendation_service.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

// --- HELPER PROVIDERS FOR STREAMS ---
// These allow us to 'watch' the database updates cleanly
final pantryStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(userDatabaseServiceProvider);
  return db.getListStream('pantry');
});

final preferencesStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(userDatabaseServiceProvider);
  return db.getPreferencesStream();
});

// --- STATE ---
class HomeState extends Equatable {
  final List<Recipe> recentMeals;
  final List<Recipe> cookNowMeals;
  final List<Recipe> recommendedMeals;
  final String recommendationTitle;

  const HomeState({
    this.recentMeals = const [],
    this.cookNowMeals = const [],
    this.recommendedMeals = const [],
    this.recommendationTitle = 'Recommended for You',
  });

  HomeState copyWith({
    List<Recipe>? recentMeals,
    List<Recipe>? cookNowMeals,
    List<Recipe>? recommendedMeals,
    String? recommendationTitle,
  }) {
    return HomeState(
      recentMeals: recentMeals ?? this.recentMeals,
      cookNowMeals: cookNowMeals ?? this.cookNowMeals,
      recommendedMeals: recommendedMeals ?? this.recommendedMeals,
      recommendationTitle: recommendationTitle ?? this.recommendationTitle,
    );
  }

  @override
  List<Object?> get props =>
      [recentMeals, cookNowMeals, recommendedMeals, recommendationTitle];
}

class HomeViewModel extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    // Get latest pantry & preferences from streams
    final pantryList = await ref.watch(pantryStreamProvider.future);
    final prefs = await ref.watch(preferencesStreamProvider.future);

    // Get Services
    final recipeService = ref.watch(recipeServiceProvider);
    final dbService = ref.watch(userDatabaseServiceProvider);
    final recommendationEngine = ref.watch(recommendationServiceProvider);

    // 1. Fetch Static Data (History & Cache)
    final historyList = await dbService.getHistory();
    final cachedRecipes = await recipeService.getCachedRecipes();

    // 2. Fallback Seed Data
    List<Recipe> allRecipes = cachedRecipes;
    if (allRecipes.isEmpty) {
      try {
        final apiResults = await Future.wait([
          recipeService.searchRecipes('dinner', const FilterState()),
        ]);
        allRecipes = [...apiResults[0]];
      } catch (e) {
        // Keep empty
      }
    }

    // 3. RE-CALCULATE LOGIC (Runs every time pantry/prefs update)

    // A. Recent Meals (Uses History)
    final recentMeals = recommendationEngine.rankRecipes(
      recipes: historyList,
      pantryItems: pantryList,
      prefs: prefs,
      mode: 'recent',
    );

    // B. Cook Now (Pantry Match)
    final cookNowMeals = recommendationEngine.rankRecipes(
      recipes: allRecipes,
      pantryItems: pantryList,
      prefs: prefs,
      mode: 'cook_now',
    );

    final finalCookNow = cookNowMeals.isNotEmpty
        ? cookNowMeals
        : recommendationEngine.rankRecipes(
            recipes: allRecipes,
            pantryItems: [],
            prefs: prefs,
            mode: 'explore');

    // C. Personalized Recommendations (Diet Match)
    List<Recipe> recommendedMeals = [];
    String recTitle = 'Top Picks for You';

    if (prefs.diets.isNotEmpty) {
      final mainDiet = prefs.diets.first;
      recTitle = 'Because you like $mainDiet';

      recommendedMeals =
          recommendationEngine.getDietaryMatches(allRecipes, mainDiet);

      if (recommendedMeals.length < 4) {
        try {
          final newRecs = await recipeService.searchRecipes(
            '',
            FilterState(tags: {mainDiet}),
          );
          recommendedMeals = newRecs;
          // Note: We don't add to allRecipes here to avoid infinite loops/complexity in this build
        } catch (e) {
          // Ignore API errors
        }
      }
    }

    if (recommendedMeals.isEmpty) {
      recTitle = 'Recommended for You';
      recommendedMeals = recommendationEngine.rankRecipes(
          recipes: allRecipes,
          pantryItems: pantryList,
          prefs: prefs,
          mode: 'explore');
    }

    return HomeState(
      recentMeals: recentMeals,
      cookNowMeals: finalCookNow,
      recommendedMeals: recommendedMeals,
      recommendationTitle: recTitle,
    );
  }
}

final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
