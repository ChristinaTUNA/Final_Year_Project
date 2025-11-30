import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/features/home/widgets/home_cooknow_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/features/home/home_viewmodel.dart';
import 'widgets/home_categorychips.dart';
import 'widgets/home_header.dart';
import 'widgets/home_recipecard.dart';

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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        data: (homeState) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    color: AppColors.primary,
                    child: const Padding(
                      padding: AppSpacing.pHorizontalLg,
                      child: HomeHeader(),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Category Chips
                  const Padding(
                    padding: AppSpacing.pHorizontalLg,
                    child: HomeCategoryChips(),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Quick Meal
                  Padding(
                    padding: AppSpacing.pHorizontalLg,
                    child: Text('Quick Meal', style: textTheme.headlineMedium),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  SizedBox(
                    height: 280,
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
                  const SizedBox(height: AppSpacing.xl),
                  // Cook Now Section
                  Padding(
                    padding: AppSpacing.pHorizontalLg,
                    child: Text('Cook Now', style: textTheme.headlineMedium),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Padding(
                    padding: AppSpacing.pHorizontalLg,
                    child: HomeCookNowSection(
                      recipe: homeState.cookNowMeals.isNotEmpty
                          ? homeState.cookNowMeals.first
                          : null,
                    ),
                  ),

                  const SizedBox(height: 200),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
