import 'package:cookit/data/models/filter_state.dart';
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

    if (query.isEmpty && filters.isEmpty) {
      return recipeService.getCachedRecipes(); // Return cached recipes
    }

    // ⬇️ Pass the complex filter state to the service
    return recipeService.searchRecipes(query, filters);
  }
}
