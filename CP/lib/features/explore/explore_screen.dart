import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/features/explore/explore_viewmodel.dart';
import 'package:cookit/features/explore/widgets/explore_recipe_gridcard.dart';
import 'package:cookit/features/explore/widgets/explore_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              Expanded(
                child: resultsAsync.when(
                  loading: () => _buildLoadingSkeleton(),
                  error: (err, stack) =>
                      Center(child: Text('Error: ${err.toString()}')),
                  data: (recipes) {
                    if (recipes.isEmpty &&
                        ref.watch(exploreSearchQueryProvider).isEmpty) {
                      return const Center(
                          child: Text('Start typing to search for recipes...'));
                    }
                    if (recipes.isEmpty) {
                      return const Center(child: Text('No results found.'));
                    }

                    return _buildMasonryGrid(recipes);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // The Real Data Grid
  Widget _buildMasonryGrid(List<Recipe> recipes) {
    final leftColumn = <Recipe>[];
    final rightColumn = <Recipe>[];

    for (var i = 0; i < recipes.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(recipes[i]);
      } else {
        rightColumn.add(recipes[i]);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftColumn
                  .map((recipe) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ExploreRecipeGridCard(recipe: recipe),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              children: rightColumn
                  .map((recipe) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ExploreRecipeGridCard(recipe: recipe),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // The Fake Skeleton Grid
  Widget _buildLoadingSkeleton() {
    // We create a list of dummy "heights" to simulate the masonry look
    final dummyHeightsLeft = [200.0, 150.0, 220.0, 180.0];
    final dummyHeightsRight = [160.0, 210.0, 140.0, 190.0];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Skeleton Column
          Expanded(
            child: Column(
              children: dummyHeightsLeft.map((height) {
                return _buildSkeletonCard(height);
              }).toList(),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Right Skeleton Column
          Expanded(
            child: Column(
              children: dummyHeightsRight.map((height) {
                return _buildSkeletonCard(height);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build a single grey box
  Widget _buildSkeletonCard(double height) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundNeutral, // Light grey
          borderRadius: BorderRadius.circular(16),
        ),
        // Optional: Add a subtle inner structure to look like text
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(height: 12, width: 80, color: Colors.white30),
            const SizedBox(height: 8),
            Container(height: 12, width: 40, color: Colors.white30),
          ],
        ),
      ),
    );
  }
}
