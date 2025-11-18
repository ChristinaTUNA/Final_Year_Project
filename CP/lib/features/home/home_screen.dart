import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/features/home/viewmodel/home_viewmodel.dart';
import 'package:cookit/features/home/widgets/home_categorychips.dart';
import 'package:cookit/features/home/widgets/home_cooknow_section.dart';
import 'package:cookit/features/home/widgets/home_header.dart';
import 'package:cookit/features/home/widgets/home_recipecard.dart';
import 'package:cookit/features/home/widgets/home_searchbar.dart';
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
          return Stack(
            children: [
              // --- Background Colors ---
              Column(
                children: [
                  Container(
                    height: 160, // Height of the red header area
                    color: AppColors.primary,
                  ),
                  Expanded(
                    child: Container(color: theme.scaffoldBackgroundColor),
                  ),
                ],
              ),

              // --- Scrollable Content ---
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: AppSpacing.pHorizontalLg, // 24px horizontal
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HomeHeader(),
                        const SizedBox(height: AppSpacing.lg), // 24px
                        const HomeSearchBar(),
                        const SizedBox(height: AppSpacing.lg), // 24px
                        const HomeCategoryChips(),
                        const SizedBox(height: AppSpacing.lg), // 24px

                        Text(
                          'Quick Meal',
                          style: textTheme.displayMedium, // 24px, w700
                        ),
                        const SizedBox(height: AppSpacing.sm), // 8px

                        SizedBox(
                          height: 320,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm),
                            itemCount: homeState.quickMeals.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final recipe = homeState.quickMeals[index];
                              return HomeRecipeCard(
                                recipe: recipe,
                                onTap: () {
                                  Navigator.pushNamed(context, '/recipe',
                                      arguments: recipe.id);
                                },
                              );
                            },
                          ),
                        ),

                        Text(
                          'Cook Now',
                          style: textTheme.displayMedium, // 24px, w700
                        ),
                        const SizedBox(height: AppSpacing.md), // 16px

                        HomeCookNowSection(
                          recipe: homeState.cookNowMeals.firstOrNull,
                        ),
                        const SizedBox(height: AppSpacing.xxl), // 48px
                      ],
                    ),
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
