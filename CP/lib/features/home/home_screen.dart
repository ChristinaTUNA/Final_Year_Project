import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/features/home/home_viewmodel.dart';
import 'package:cookit/features/home/widgets/home_categorychips.dart';
import 'package:cookit/features/home/widgets/home_header.dart';
import 'package:cookit/features/home/widgets/home_horizontal_list.dart';
import 'package:cookit/features/shared/common_recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final homeStateAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: homeStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        data: (homeState) {
          return SingleChildScrollView(
            child: Stack(
              children: [
                // 1. Red Header Background
                Container(
                  height: 150,
                  width: double.infinity,
                  color: AppColors.primary,
                ),

                // 2. Main Content
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- HEADER AREA ---
                      const Padding(
                        padding: AppSpacing.pHorizontalLg,
                        child: Column(
                          children: [
                            HomeHeader(),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // --- CATEGORIES ---
                      const Padding(
                        padding: AppSpacing.pHorizontalLg,
                        child: HomeCategoryChips(),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // --- SECTION 1: RECENTLY VIEWED ---
                      HomeHorizontalSection(
                        title: 'Recently Viewed',
                        recipes: homeState.recentMeals,
                      ),

                      // --- SECTION 2: PERSONALIZED ---
                      HomeHorizontalSection(
                        title: homeState.recommendationTitle,
                        recipes: homeState.recommendedMeals,
                      ),

                      // --- SECTION 3: COOK NOW (Featured) ---
                      if (homeState.cookNowMeals.isNotEmpty) ...[
                        Padding(
                          padding: AppSpacing.pHorizontalLg,
                          child: Text(
                            'Cook Now',
                            style: textTheme.headlineMedium,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...homeState.cookNowMeals.take(5).map((recipe) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.lg,
                                left: AppSpacing.lg,
                                right: AppSpacing.lg),
                            child: CommonRecipeCard(
                              recipe: recipe,
                              imageHeight: 180,
                            ),
                          );
                        }).toList(),
                      ],

                      // Extra space at bottom
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
