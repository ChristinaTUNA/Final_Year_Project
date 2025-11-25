import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/features/home/widgets/home_cooknow_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/features/home/home_viewmodel.dart';
import 'widgets/home_categorychips.dart';
import 'widgets/home_header.dart';
import 'widgets/home_recipecard.dart';
import 'widgets/home_searchbar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    // Watch the API-connected provider
    final homeStateAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: homeStateAsync.when(
        // Loading State
        loading: () => const Center(child: CircularProgressIndicator()),

        // Error State
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),

        // Data State
        data: (homeState) {
          return Stack(
            children: [
              // 1. THE BACKGROUND LAYER
              Column(
                children: [
                  // The Red Header Background
                  Container(
                    height: 220, // Covers header + part of search bar
                    color: AppColors.primary,
                  ),
                  // The White Body Background
                  Expanded(
                    child: Container(color: theme.scaffoldBackgroundColor),
                  ),
                ],
              ),

              // 2. THE CONTENT LAYER
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wrapper for top padding
                      Padding(
                        padding: AppSpacing.pHorizontalLg
                            .copyWith(top: AppSpacing.md),
                        child: const Column(
                          children: [
                            HomeHeader(),
                            SizedBox(height: AppSpacing.lg),
                            HomeSearchBar(),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Category Chips
                      const Padding(
                        padding: AppSpacing.pHorizontalLg,
                        child: HomeCategoryChips(),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Quick Meal Section
                      Padding(
                        padding: AppSpacing.pHorizontalLg,
                        child: Text(
                          'Quick Meal',
                          style: textTheme.headlineMedium, // 22px Bold
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Horizontal List
                      SizedBox(
                        height: 280, // Adjusted height for cards
                        child: homeState.quickMeals.isEmpty
                            ? const Center(child: Text("No quick meals found."))
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg, vertical: 8),
                                itemCount: homeState.quickMeals.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: AppSpacing.md),
                                itemBuilder: (context, index) {
                                  final recipe = homeState.quickMeals[index];
                                  return HomeRecipeCard(recipe: recipe);
                                },
                              ),
                      ),

                      // Cook Now Section
                      Padding(
                        padding: AppSpacing.pHorizontalLg,
                        child: Text(
                          'Cook Now',
                          style: textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      Padding(
                        padding: AppSpacing.pHorizontalLg,
                        child: HomeCookNowSection(
                          // Pass the first item, or null if empty
                          recipe: homeState.cookNowMeals.isNotEmpty
                              ? homeState.cookNowMeals.first
                              : null,
                        ),
                      ),

                      // Bottom padding for scrolling past FAB
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
