import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/features/recipe/recipe_viewmodel.dart';
import 'package:cookit/features/recipe/widgets/recipe_header.dart';
import 'package:cookit/features/recipe/widgets/recipe_ratingbar.dart';
import 'package:cookit/features/recipe/widgets/recipe_ingredient_tile.dart';
import 'package:cookit/features/recipe/widgets/recipe_meta_info.dart';

class RecipeScreen extends ConsumerWidget {
  final int recipeId;
  const RecipeScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(recipeViewModelProvider(recipeId));
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    Future<void> onAddToShopping() async {
      final count = await ref
          .read(recipeViewModelProvider(recipeId).notifier)
          .addSelectedToShoppingList();

      if (count > 0 && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $count items to shopping list'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }

    // Handle Loading/Error states simply for the whole screen
    return stateAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (state) {
        final recipe = state.recipe;
        final viewModel = ref.read(recipeViewModelProvider(recipeId).notifier);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280.0,
                floating: false,
                pinned: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // The Image
                      Image.network(
                        recipe.image,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(
                          color: AppColors.backgroundNeutral,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),

                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black45],
                            stops: [0.7, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //  3. The Content Body
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    padding: AppSpacing.pHorizontalLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        const SizedBox(height: AppSpacing.xl),
                        RecipeHeader(
                          title: recipe.title,
                          isFavorite: state.isFavorite,
                          onToggle: () => viewModel.toggleFavorite(),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        RecipeRatingBar(rating: recipe.rating),
                        const SizedBox(height: AppSpacing.md),

                        // Meta Info
                        RecipeMetaInfo(
                          time: recipe.time,
                          servings: recipe.servings ?? 2,
                          tag1: recipe.subtitle1,
                          tag2: recipe.subtitle2,
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Ingredients
                        Text('Ingredients', style: textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.sm),

                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.ingredients.length,
                          itemBuilder: (context, i) {
                            final ing = state.ingredients[i];
                            return RecipeIngredientTile(
                              ingredient: ing,
                              onToggle: () => viewModel.toggleIngredient(i),
                            );
                          },
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Add Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state.anyIngredientSelected
                                ? onAddToShopping
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: state.anyIngredientSelected
                                  ? AppColors.primary
                                  : AppColors.backgroundNeutral,
                              foregroundColor: state.anyIngredientSelected
                                  ? AppColors.white
                                  : AppColors.textLightGray,
                              textStyle: AppTextStyles.labelLarge,
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: AppBorders.allMd),
                            ),
                            child: const Text('Add to Shopping List'),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Health Score
                        ExpansionTile(
                          title:
                              Text('Health Score', style: textTheme.titleSmall),
                          trailing: Text(
                            recipe.healthScore != null
                                ? '${recipe.healthScore!.round()}/100'
                                : 'N/A',
                            style: textTheme.bodyMedium,
                          ),
                          initiallyExpanded: state.nutritionExpanded,
                          onExpansionChanged: viewModel.toggleNutrition,
                          children: [
                            Padding(
                              padding: AppSpacing.pAllSm,
                              child: Text(
                                recipe.healthScore != null
                                    ? 'This recipe has a health score of ${recipe.healthScore!.round()}% according to Spoonacular.'
                                    : 'No health score available.',
                                style: textTheme.bodyMedium,
                              ),
                            )
                          ],
                        ),

                        // Instructions
                        ExpansionTile(
                          title:
                              Text('Instructions', style: textTheme.titleSmall),
                          initiallyExpanded: true,
                          children: [
                            Padding(
                              padding: AppSpacing.pAllSm,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: recipe.instructions.isEmpty
                                    ? [const Text("No instructions available.")]
                                    : recipe.instructions.map((section) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (section.name.isNotEmpty)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical:
                                                            AppSpacing.sm),
                                                child: Text(
                                                  section.name,
                                                  style: textTheme.titleSmall,
                                                ),
                                              ),
                                            ...section.steps.map((step) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical:
                                                            AppSpacing.xs),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${step.number}. ',
                                                      style: textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        step.step,
                                                        style: textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ],
                                        );
                                      }).toList(),
                              ),
                            ),
                          ],
                        ),
                        // Bottom Padding
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
