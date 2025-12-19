import 'package:cookit/data/models/filter_state.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/services/recipe_service.dart';
import 'package:cookit/data/services/recommendation_service.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

final pantryStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(userDatabaseServiceProvider);
  return db.getListStream('pantry');
});

final preferencesStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(userDatabaseServiceProvider);
  return db.getPreferencesStream();
});

final historyStreamProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(userDatabaseServiceProvider);
  return db.getHistoryStream();
});

class HomeState extends Equatable {
  final List<Recipe> recentMeals;
  final List<Recipe> cookNowMeals;
  final List<Recipe> recommendedMeals;
  final String recommendationTitle;
  final bool hasPantryItems;

  const HomeState({
    this.recentMeals = const [],
    this.cookNowMeals = const [],
    this.recommendedMeals = const [],
    this.recommendationTitle = 'Recommended for You',
    this.hasPantryItems = false,
  });

  HomeState copyWith({
    List<Recipe>? recentMeals,
    List<Recipe>? cookNowMeals,
    List<Recipe>? recommendedMeals,
    String? recommendationTitle,
    bool? hasPantryItems,
  }) {
    return HomeState(
      recentMeals: recentMeals ?? this.recentMeals,
      cookNowMeals: cookNowMeals ?? this.cookNowMeals,
      recommendedMeals: recommendedMeals ?? this.recommendedMeals,
      recommendationTitle: recommendationTitle ?? this.recommendationTitle,
      hasPantryItems: hasPantryItems ?? this.hasPantryItems,
    );
  }

  @override
  List<Object?> get props => [
        recentMeals,
        cookNowMeals,
        recommendedMeals,
        recommendationTitle,
        hasPantryItems
      ];
}

class HomeViewModel extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    final pantryList = await ref.watch(pantryStreamProvider.future);
    final prefs = await ref.watch(preferencesStreamProvider.future);
    final historyList = await ref.watch(historyStreamProvider.future);

    final recipeService = ref.watch(recipeServiceProvider);
    final recommendationEngine = ref.watch(recommendationServiceProvider);

    final cachedRecipes = await recipeService.getCachedRecipes();

    // Seed Data if cache empty
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
    allRecipes.shuffle();

    // 1. Recent Meals
    final recentMeals = recommendationEngine.rankRecipes(
      recipes: historyList,
      pantryItems: pantryList,
      prefs: prefs,
      mode: 'recent',
    );

    // 2. Cook Now (First Pass: Local Cache)
    var cookNowMeals = recommendationEngine.rankRecipes(
      recipes: allRecipes,
      pantryItems: pantryList,
      prefs: prefs,
      mode: 'cook_now',
    );

    // Active Fetch if Cache Fails
    // If we have pantry items BUT no cook now matches, the API will handle
    if (cookNowMeals.isEmpty && pantryList.isNotEmpty) {
      try {
        final topIngredients = pantryList.take(4).map((e) => e.name).join(',');

        // This triggers '_searchByIngredients' in RecipeService
        final apiMatches = await recipeService.searchRecipes(
            topIngredients, const FilterState());

        // Re-rank these new results
        cookNowMeals = recommendationEngine.rankRecipes(
          recipes: apiMatches,
          pantryItems: pantryList,
          prefs: prefs,
          mode: 'cook_now',
        );

        // Add to main pool so they might show up in "Recommended" too
        allRecipes.addAll(apiMatches);
      } catch (e) {
        // Fallback continues below
      }
    }

    // Fallback: If STILL empty, show generic recommended recipes
    // (This avoids showing "Garlic Soup" to someone without Garlic,
    // but fills the space if we really failed to match anything)
    final finalCookNow = cookNowMeals.isNotEmpty
        ? cookNowMeals
        : recommendationEngine.rankRecipes(
            recipes: allRecipes,
            pantryItems: [],
            prefs: prefs,
            mode: 'explore');

    // 3. Personalized Recommendations
    final cookNowIds = finalCookNow.map((r) => r.id).toSet();
    var recipePoolForRecs =
        allRecipes.where((r) => !cookNowIds.contains(r.id)).toList();

    if (recipePoolForRecs.isEmpty) {
      recipePoolForRecs = List.from(allRecipes);
    }

    List<Recipe> recommendedMeals = [];
    String recTitle = 'Top Picks for You';

    if (prefs.diets.isNotEmpty) {
      final mainDiet = prefs.diets.first;
      recTitle = 'Because you like $mainDiet';

      recommendedMeals =
          recommendationEngine.getDietaryMatches(recipePoolForRecs, mainDiet);

      if (recommendedMeals.length < 4) {
        try {
          final newRecs = await recipeService.searchRecipes(
            '',
            FilterState(tags: {mainDiet}),
          );
          final uniqueNewRecs =
              newRecs.where((r) => !cookNowIds.contains(r.id)).toList();
          recommendedMeals = uniqueNewRecs.isNotEmpty ? uniqueNewRecs : newRecs;
          allRecipes.addAll(newRecs);
        } catch (e) {
          // Ignore
        }
      }
    }

    if (recommendedMeals.isEmpty) {
      recTitle = 'Recommended for You';
      recommendedMeals = recommendationEngine.rankRecipes(
          recipes: recipePoolForRecs,
          pantryItems: pantryList,
          prefs: prefs,
          mode: 'explore');
    }

    return HomeState(
      recentMeals: recentMeals,
      cookNowMeals: finalCookNow,
      recommendedMeals: recommendedMeals,
      recommendationTitle: recTitle,
      hasPantryItems: pantryList.isNotEmpty,
    );
  }
}

final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
