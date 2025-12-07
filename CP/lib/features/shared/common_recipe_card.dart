import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_decoration.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:flutter/material.dart';

class CommonRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final double imageHeight;

  const CommonRecipeCard({
    super.key,
    required this.recipe,
    this.imageHeight = 160,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final bgColor = theme.brightness == Brightness.light
        ? AppColors.background
        : AppColors.cardBackgroundDark;

    // Detect if this is a "Cheap" Pantry search result
    final bool isPantryMatch =
        (recipe.usedIngredientCount > 0 || recipe.missedIngredientCount > 0);

    // Check if we even HAVE time/rating data (from expensive search)
    final bool hasDetails = recipe.time != null && recipe.rating != null;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/recipe', arguments: recipe.id);
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 200),
        decoration: AppDecorations.elevatedCardStyle.copyWith(
          color: bgColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- 1. Image Section ---
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorders.radiusLg),
                topRight: Radius.circular(AppBorders.radiusLg),
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: 'recipe_image_${recipe.id}',
                    child: Image.network(
                      recipe.image,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        height: imageHeight,
                        width: double.infinity,
                        color: AppColors.backgroundNeutral,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),

                  // 💡 PANTRY BADGE (Top Right)
                  if (isPantryMatch)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          // Green if you have almost everything, Red if missing lots
                          color: recipe.missedIngredientCount == 0
                              ? Colors.green.withValues(alpha: 0.95)
                              : AppColors.primary.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Text(
                          recipe.missedIngredientCount == 0
                              ? 'Fully Matched!'
                              : 'Missing ${recipe.missedIngredientCount} items',
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // --- 2. Content Section ---
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm).copyWith(
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // ADAPTIVE FOOTER
                  if (isPantryMatch)
                    // --- OPTION A: Pantry View (2 Lines) ---
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Line 1: Positive reinforcement ("You have 5")
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              'You have ${recipe.usedIngredientCount} items',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6), // Spacing between lines

                        // Line 2: Call to Action (Aligned Right for cleaner look)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'View Recipe ›',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (hasDetails)
                    // --- OPTION B: Standard View (Full Data) ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded,
                                size: 16, color: AppColors.textLightGray),
                            const SizedBox(width: 4),
                            Text(
                              recipe.time ?? '',
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 2),
                            Text(
                              recipe.rating?.toStringAsFixed(1) ?? '',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  else
                    // --- OPTION C: Fallback (Just Text) ---
                    Text(
                      'Tap to view details',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textLightGray,
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
