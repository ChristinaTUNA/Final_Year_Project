import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_decoration.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:flutter/material.dart';

class CommonRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final double imageHeight;
  final bool useHeroAnimation;

  const CommonRecipeCard({
    super.key,
    required this.recipe,
    this.imageHeight = 160, // Default height
    this.useHeroAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    // Determine background color based on brightness
    final bgColor = theme.brightness == Brightness.light
        ? AppColors.background
        : AppColors.cardBackgroundDark;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/recipe', arguments: recipe.id);
      },
      child: Container(
        // Unified Card Decoration
        decoration: AppDecorations.elevatedCardStyle.copyWith(
          color: bgColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorders.radiusLg),
                topRight: Radius.circular(AppBorders.radiusLg),
              ),
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

            // 2. Content Section
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

                  // Meta Row (Time, Rating)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side: Diet or Time
                      Expanded(
                        child: Text(
                          '${recipe.subtitle1 ?? ''}\n${recipe.time ?? 'N/A'}',
                          style: textTheme.bodyMedium?.copyWith(height: 1.3),
                          maxLines: 2,
                        ),
                      ),
                      // Right side: Rating
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.rating, size: 18),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            recipe.rating?.toStringAsFixed(1) ?? 'N/A',
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
