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
  bool _isLoadingMore = false;
  bool _hasMore = true;
  @override
  Future<List<Recipe>> build() async {
    _isLoadingMore = false;
    _hasMore = true;

    final query = ref.watch(exploreSearchQueryProvider);
    final filters = ref.watch(exploreFilterStateProvider);
    final recipeService = ref.watch(recipeServiceProvider);

    final dbService = ref.watch(userDatabaseServiceProvider);
    final recommendationEngine = ref.watch(recommendationServiceProvider);

    // 1. Fetch Raw Recipes (From Cache or API)
    List<Recipe> rawResults;
    if (query.isEmpty && filters.isEmpty) {
      rawResults = await recipeService.getCachedRecipes();
      _hasMore = false; // No pagination for cached
    } else {
      rawResults = await recipeService.searchRecipes(query, filters, offset: 0);
      if (rawResults.isEmpty) _hasMore = false;
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

  Future<void> loadMore() async {
    // 1. Safety Checks
    if (_isLoadingMore || !_hasMore || state.value == null) return;

    // ⬇️ REMOVED: if (query.isEmpty) return;
    // We WANT to load more even if query is empty (Browse Mode).

    _isLoadingMore = true;

    try {
      final query = ref.read(exploreSearchQueryProvider);
      final filters = ref.read(exploreFilterStateProvider);
      final recipeService = ref.read(recipeServiceProvider);

      final currentList = state.value!;
      final offset = currentList.length;

      // 2. Fetch Next Batch
      // If query is empty, we pass an empty string. The Service handles empty string
      // by fetching popular/random recipes (via complexSearch).
      final nextBatch = await recipeService.searchRecipes(
        query,
        filters,
        offset: offset,
      );

      if (nextBatch.isEmpty) {
        _hasMore = false;
      } else {
        // 3. Append & Update
        // Note: We don't re-rank the *entire* combined list here to prevent
        // older items from jumping around. We just append the new batch.
        state = AsyncData([...currentList, ...nextBatch]);
      }
    } catch (e) {
      throw Exception('Load more error: $e');
    } finally {
      _isLoadingMore = false;
    }
  }
}
