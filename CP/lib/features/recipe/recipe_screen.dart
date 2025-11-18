// lib/features/recipe/recipe_screen.dart
import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/data/models/list_item.dart';
import 'package:cookit/data/services/shopping_service.dart';
import 'package:cookit/features/recipe/recipe_viewmodel.dart';
import 'package:cookit/features/recipe/widgets/recipe_header.dart';
import 'package:cookit/features/recipe/widgets/recipe_ratingbar.dart';
import 'package:cookit/features/recipe/widgets/recipe_servings_control.dart';
import 'package:cookit/features/recipe/widgets/recipe_ingredient_tile.dart';

class RecipeScreen extends ConsumerWidget {
  final int recipeId;
  const RecipeScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(recipeViewModelProvider(recipeId));
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    void addToShopping() {
      final viewModel = ref.read(recipeViewModelProvider(recipeId).notifier);
      final items = viewModel.getSelectedShoppingItems();
      if (items.isEmpty) return;

      final listItems =
          items.map((e) => ListItem(name: e.name, quantity: e.amount)).toList();

      ref.read(shoppingServiceProvider).addAll(listItems);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${items.length} items to shopping list'),
        ),
      );
      viewModel.clearSelections();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(elevation: 0),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        data: (state) {
          final recipe = state.recipe;
          final viewModel =
              ref.read(recipeViewModelProvider(recipeId).notifier);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: AppBorders.allLg,
                  child: Image.network(
                    recipe.image,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(
                        height: 220, color: AppColors.backgroundNeutral),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: AppSpacing.pHorizontalLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RecipeHeader(
                        title: recipe.title,
                        onBookmark: () {},
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      RecipeRatingBar(rating: recipe.rating),
                      const SizedBox(height: AppSpacing.md),
                      RecipeServingsControl(
                        servings: state.servings,
                        onDecrement: viewModel.decrementServings,
                        onIncrement: viewModel.incrementServings,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Ingredients', style: textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.sm),
                      ListView.builder(
                        itemCount: state.ingredients.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          final ing = state.ingredients[i];
                          return RecipeIngredientTile(
                            ingredient: ing,
                            onToggle: () => viewModel.toggleIngredient(i),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.anyIngredientSelected
                              ? addToShopping
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.anyIngredientSelected
                                ? AppColors.primary
                                : AppColors.backgroundNeutral,
                            foregroundColor: state.anyIngredientSelected
                                ? AppColors.white
                                : AppColors.textLightGray,
                            textStyle: AppTextStyles.button,
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md),
                            shape: const RoundedRectangleBorder(
                                borderRadius: AppBorders.allMd),
                          ),
                          child: const Text('Add to Shopping List'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ExpansionTile(
                        title: Text('Nutritions', style: textTheme.titleSmall),
                        trailing: Text('100gr', style: textTheme.bodyMedium),
                        initiallyExpanded: state.nutritionExpanded,
                        onExpansionChanged: viewModel.toggleNutrition,
                        children: [
                          Padding(
                            padding: AppSpacing.pAllSm,
                            child: Text(
                              'Calories: 220 kcal\nProtein: 18g\nFat: 12g',
                              style: textTheme.bodyMedium,
                            ),
                          )
                        ],
                      ),
                      ExpansionTile(
                        title:
                            Text('Instructions', style: textTheme.titleSmall),
                        initiallyExpanded: true,
                        children: [
                          Padding(
                            padding: AppSpacing.pAllSm,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // 1. Map over each SECTION
                              children: recipe.instructions.map((section) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 2. Display the section NAME
                                    if (section.name.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: AppSpacing.sm),
                                        child: Text(
                                          section.name,
                                          style: textTheme
                                              .titleSmall, // 14px, w600
                                        ),
                                      ),
                                    // 3. Map over each STEP in the section
                                    ...section.steps.map((step) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: AppSpacing.xs),
                                        // 4. Create a Row for "1. Do the thing"
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${step.number}. ',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                step.step,
                                                style: textTheme.bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
