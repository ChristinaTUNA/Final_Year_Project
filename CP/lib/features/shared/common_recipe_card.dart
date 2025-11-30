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

    // 🧠 SMART LOGIC:
    // Check if this recipe has "Pantry Data" (from the scanner)
    final bool isPantryMatch =
        (recipe.usedIngredientCount > 0 || recipe.missedIngredientCount > 0);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/recipe', arguments: recipe.id);
      },
      child: Container(
        decoration: AppDecorations.elevatedCardStyle.copyWith(
          color: bgColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Image Section ---
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorders.radiusLg),
                topRight: Radius.circular(AppBorders.radiusLg),
              ),
              child: Stack(
                children: [
                  Image.network(
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

                  // 💡 FEATURE: "Missing Ingredients" Badge
                  // Only shows if this is a pantry match and you are missing items
                  if (isPantryMatch && recipe.missedIngredientCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: .9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Missing: ${recipe.missedIngredientCount}',
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
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.title,
                    style: textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Metadata Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LEFT SIDE: Time or "You have X ingredients"
                      if (isPantryMatch)
                        // If pantry match, show "You have X"
                        Expanded(
                          child: Text(
                            'You have ${recipe.usedIngredientCount} items',
                            style: textTheme.bodyMedium?.copyWith(
                              color:
                                  AppColors.primary, // Highlight in Green/Red
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        )
                      else
                        // Otherwise, show standard Time
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 14, color: AppColors.textLightGray),
                              const SizedBox(width: 4),
                              Text(
                                recipe.time ?? 'N/A',
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),

                      // RIGHT SIDE: Rating
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.rating, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            recipe.rating != null && recipe.rating! > 0
                                ? recipe.rating!.toStringAsFixed(1)
                                : 'N/A',
                            style: textTheme.bodyMedium,
                          )
                        ],
                      )
                    ],
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
