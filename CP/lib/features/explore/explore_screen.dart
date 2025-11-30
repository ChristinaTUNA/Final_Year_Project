import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/explore_recipe_gridcard.dart';
import 'widgets/explore_searchbar.dart';
import 'explore_viewmodel.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final resultsAsync = ref.watch(exploreResultsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding:
              AppSpacing.pHorizontalLg.copyWith(top: AppSpacing.xl, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Recipes',
                style: textTheme.displayMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              const ExploreSearchBar(),
              const SizedBox(height: AppSpacing.md),

              // 2. Use .when() to show results, loading, or error
              Expanded(
                child: resultsAsync.when(
                  //
                  // --- LOADING STATE ---
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  //
                  // --- ERROR STATE ---
                  error: (err, stack) =>
                      Center(child: Text('Error: ${err.toString()}')),
                  data: (recipes) {
                    if (recipes.isEmpty &&
                        ref.watch(exploreSearchQueryProvider).isEmpty) {
                      return const Center(
                          child: Text('Start typing to search for recipes...'));
                    }
                    // If we searched but found nothing
                    if (recipes.isEmpty) {
                      return const Center(child: Text('No results found.'));
                    }
                    // If we have recipes, show them in the grid
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: AppSpacing.sm,
                        mainAxisSpacing: AppSpacing.sm,
                      ),
                      itemCount: recipes.length,
                      itemBuilder: (context, i) =>
                          ExploreRecipeGridCard(recipe: recipes[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
