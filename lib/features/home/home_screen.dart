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
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(homeViewModelProvider);
              await ref.read(homeViewModelProvider.future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                        Padding(
                          padding: AppSpacing.pHorizontalLg
                              .copyWith(top: AppSpacing.md),
                          child: const Column(
                            children: [
                              HomeHeader(),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // --- CATEGORIES ---

                        const HomeCategoryChips(),

                        const SizedBox(height: AppSpacing.xl),

                        // --- SECTION 1: RECENTLY VIEWED ---
                        // Uses shared widget for consistency
                        HomeHorizontalSection(
                          title: 'Recently Viewed',
                          recipes: homeState.recentMeals,
                          showPantryBadges: false, // Show Time/Rating
                        ),

                        // --- SECTION 2: PERSONALIZED ---
                        HomeHorizontalSection(
                          title: homeState.recommendationTitle,
                          recipes: homeState.recommendedMeals,
                          showPantryBadges: false, // Show Time/Rating
                        ),

                        // --- SECTION 3: COOK NOW (Vertical Feed) ---
                        Padding(
                          padding: AppSpacing.pHorizontalLg,
                          child: Text(
                            'Cook Now',
                            style: textTheme.headlineMedium,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        if (!homeState.hasPantryItems)
                          _buildColdStartCTA(context)
                        else if (homeState.cookNowMeals.isNotEmpty)
                          ...homeState.cookNowMeals.take(5).map((recipe) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.sm,
                              ),
                              child: CommonRecipeCard(
                                recipe: recipe,
                                imageHeight: 180,
                                showPantryBadges: true,
                              ),
                            );
                          }),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColdStartCTA(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.camera_alt_outlined,
              size: 48, color: AppColors.primary),
          const SizedBox(height: 16),
          const Text(
            "Your pantry is empty!",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          const Text(
            "Scan your first ingredient to unlock personalized 'Cook Now' suggestions.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGray),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scan');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text("Scan Ingredients"),
            ),
          ),
        ],
      ),
    );
  }
}
