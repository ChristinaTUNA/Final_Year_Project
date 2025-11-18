import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/services/recipe_service.dart';

// --- INPUT PROVIDERS ---

/// 1. Holds the user's typed search query.
/// We use 'StateProvider' as it's simple and set by the UI.
final exploreSearchQueryProvider = StateProvider<String>((ref) {
  return ''; // Default is an empty search
});

/// 2. Holds the user's selected filter chip.
final exploreSelectedFilterProvider = StateProvider<String>((ref) {
  return 'All'; // Default is 'All' filter
});

// --- "BRAIN" PROVIDER (This is the magic) ---

/// 3. This provider automatically re-runs when the query or filter changes.
/// It fetches the new list of recipes from the Spoonacular API.
final exploreResultsProvider =
    AsyncNotifierProvider<ExploreViewModel, List<Recipe>>(
  () => ExploreViewModel(),
);

class ExploreViewModel extends AsyncNotifier<List<Recipe>> {
  @override
  Future<List<Recipe>> build() async {
    // ⬇️ 1. Watch the input providers
    final query = ref.watch(exploreSearchQueryProvider);
    final filter = ref.watch(exploreSelectedFilterProvider);

    // ⬇️ 2. If there's no search query, return an empty list.
    //    This prevents an API call on the first load.
    if (query.isEmpty) {
      return [];
    }

    // ⬇️ 3. A query exists! Set loading state and call the API.
    //    This is 100% safe. This code only runs when
    //    'query' or 'filter' *changes*. (Cost: 1 point)
    final recipeService = ref.watch(recipeServiceProvider);
    return recipeService.searchRecipes(query, filter);
  }
}
