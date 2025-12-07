import 'package:cookit/data/models/filter_state.dart';
import 'package:cookit/data/services/recommendation_service.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/services/recipe_service.dart';

// --- PROVIDERS ---
/// 1. Holds the search query text
final exploreSearchQueryProvider = StateProvider<String>((ref) => '');

/// 2. Holds the currently APPLIED filters (used for API calls)
final exploreFilterStateProvider = StateProvider<FilterState>((ref) {
  return const FilterState();
});

/// 3. This is the provider that fetches results
final exploreResultsProvider =
    AsyncNotifierProvider<ExploreViewModel, List<Recipe>>(
  () => ExploreViewModel(),
);

class ExploreViewModel extends AsyncNotifier<List<Recipe>> {
  @override
  Future<List<Recipe>> build() async {
    final query = ref.watch(exploreSearchQueryProvider);
    final filters = ref.watch(exploreFilterStateProvider);
    final recipeService = ref.watch(recipeServiceProvider);
    final dbService = ref.watch(userDatabaseServiceProvider);
    final recommendationEngine = ref.watch(recommendationServiceProvider);

    // 1. Fetch Raw Recipes (From Cache or API)
    List<Recipe> rawResults;
    if (query.isEmpty && filters.isEmpty) {
      rawResults = await recipeService.getCachedRecipes();
    } else {
      rawResults = await recipeService.searchRecipes(query, filters);
    }

    // 2. Apply "Smart Rank" if selected (or if default)
    if (filters.sortBy.isEmpty || filters.sortBy == 'Smart Rank') {
      // Fetch context
      final pantryList = await dbService.getListStream('pantry').first;
      final prefs = await dbService.getPreferences();

      // Run the Engine
      return recommendationEngine.rankRecipes(
        recipes: rawResults,
        pantryItems: pantryList,
        prefs: prefs,
        mode: 'explore',
      );
    }

    // If sorting by something else (e.g. 'Prep Time'), just return raw results
    return rawResults;
  }
}
