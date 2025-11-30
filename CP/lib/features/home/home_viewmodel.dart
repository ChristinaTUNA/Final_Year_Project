import 'package:cookit/data/models/filter_state.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/services/recipe_service.dart';
import 'package:cookit/data/services/recommendation_service.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

// --- STATE ---
class HomeState extends Equatable {
  final List<Recipe> quickMeals;
  final List<Recipe> cookNowMeals;

  const HomeState({
    this.quickMeals = const [],
    this.cookNowMeals = const [],
  });

  HomeState copyWith({
    List<Recipe>? quickMeals,
    List<Recipe>? cookNowMeals,
  }) {
    return HomeState(
      quickMeals: quickMeals ?? this.quickMeals,
      cookNowMeals: cookNowMeals ?? this.cookNowMeals,
    );
  }

  @override
  List<Object?> get props => [quickMeals, cookNowMeals];
}

class HomeViewModel extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    return _loadHomeData();
  }

  Future<HomeState> _loadHomeData() async {
    // 1. Get all the tools we need
    final recipeService = ref.watch(recipeServiceProvider);
    final dbService = ref.watch(userDatabaseServiceProvider);
    final recommendationEngine = ref.watch(recommendationServiceProvider);

    // 2. Fetch Raw Data (Recipes + User Context)
    // Fetch cached recipes (0 points)
    final rawRecipes = await recipeService.getCachedRecipes();

    // Fetch user context (Pantry + Prefs)
    // We take the first item from the stream to get a snapshot
    final pantryList = await dbService.getListStream('pantry').first;
    final prefs = await dbService.getPreferences();

    // 3. Fallback: Seed data from API if cache is totally empty
    List<Recipe> allRecipes = rawRecipes;
    if (allRecipes.isEmpty) {
      try {
        final apiResults = await Future.wait([
          recipeService.searchRecipes('quick', const FilterState()),
          recipeService.searchRecipes('dinner', const FilterState()),
        ]);
        allRecipes = [...apiResults[0], ...apiResults[1]];
      } catch (e) {
        return const HomeState();
      }
    }

    // 4. THE MAGIC: Use the Universal Engine 🪄

    // Logic for Quick Meals (Filter: Time < 20, Sort: Score)
    final quickMeals = recommendationEngine.rankRecipes(
      recipes: allRecipes,
      pantryItems: pantryList,
      prefs: prefs,
      mode: 'quick',
    );

    // Logic for Cook Now (Filter: High Pantry Match, Sort: Score)
    final cookNowMeals = recommendationEngine.rankRecipes(
      recipes: allRecipes,
      pantryItems: pantryList,
      prefs: prefs,
      mode: 'cook_now',
    );

    // Safety: If "Cook Now" is empty (user has no ingredients), fallback to "Explore" mode
    final finalCookNow = cookNowMeals.isNotEmpty
        ? cookNowMeals
        : recommendationEngine.rankRecipes(
            recipes: allRecipes,
            pantryItems: [],
            prefs: prefs,
            mode: 'explore');

    return HomeState(
      quickMeals: quickMeals,
      cookNowMeals: finalCookNow,
    );
  }
}

// --- PROVIDER ---
final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
