import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
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

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please login to save recipes to your favorites.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Login Now',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

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
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

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
              // --- 1. HERO IMAGE HEADER ---
              SliverAppBar(
                expandedHeight: 320.0,
                floating: false,
                pinned: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        recipe.image,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(
                          color: AppColors.backgroundNeutral,
                          child: const Icon(Icons.image_not_supported,
                              size: 50, color: Colors.grey),
                        ),
                      ),
                      // Gradient overlay for better text contrast if needed
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black12, Colors.transparent],
                            stops: [0.0, 0.3],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- 2. SCROLLABLE CONTENT ---
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -24), // Overlap effect
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: AppSpacing.pHorizontalLg.copyWith(top: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- TITLE & RATING ---
                        RecipeHeader(
                          title: recipe.title,
                          isFavorite: state.isFavorite,
                          onToggle: () {
                            if (state.isGuest) {
                              _showLoginDialog(context);
                            } else {
                              viewModel.toggleFavorite();
                            }
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        RecipeRatingBar(rating: recipe.rating),
                        const SizedBox(height: AppSpacing.lg),

                        // --- META BADGES (Time, Servings, Tags) ---
                        RecipeMetaInfo(
                          time: recipe.time,
                          servings: recipe.servings ?? 2,
                          tag1: recipe.subtitle1,
                          tag2: recipe.subtitle2,
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Divider(height: 1, color: AppColors.divider),
                        ),

                        // --- INGREDIENTS SECTION ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ingredients',
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${state.ingredients.length} items',
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Ingredients List
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

                        const SizedBox(height: AppSpacing.lg),

                        // Add Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: state.anyIngredientSelected
                                ? onAddToShopping
                                : null,
                            icon: const Icon(Icons.shopping_cart_outlined),
                            label: const Text('Add to Shopping List'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: state.anyIngredientSelected
                                  ? AppColors.primary
                                  : AppColors.backgroundNeutral,
                              foregroundColor: state.anyIngredientSelected
                                  ? AppColors.white
                                  : AppColors.textLightGray,
                              elevation: 0,
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Divider(height: 1, color: AppColors.divider),
                        ),

                        // --- HEALTH SCORE CARD ---
                        if (recipe.healthScore != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    '${recipe.healthScore!.round()}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Health Score',
                                        style: textTheme.titleMedium?.copyWith(
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Based on nutritional density.',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: AppSpacing.xl),

                        // --- INSTRUCTIONS SECTION ---
                        Text(
                          'Instructions',
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        if (recipe.instructions.isEmpty)
                          const Text("No instructions available.")
                        else
                          ...recipe.instructions.map((section) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (section.name.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppSpacing.sm),
                                    child: Text(
                                      section.name,
                                      style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ...section.steps.map((step) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: AppSpacing.lg),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Step Number Circle
                                        Container(
                                          width: 28,
                                          height: 28,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '${step.number}',
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Step Text
                                        Expanded(
                                          child: Text(
                                            step.step,
                                            style:
                                                textTheme.bodyMedium?.copyWith(
                                              height: 1.6, // Readable spacing
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            );
                          }),

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
