import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_decoration.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:flutter/material.dart';

class ExploreRecipeGridCard extends StatelessWidget {
  final Recipe recipe;
  const ExploreRecipeGridCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bgColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.background
        : AppColors.cardBackgroundDark;

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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorders.radiusLg),
                topRight: Radius.circular(AppBorders.radiusLg),
              ),
              child: Image.network(
                recipe.image,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 140,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image,
                        color: Colors.grey, size: 40),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          // Combine subtitle and time, filtering out nulls
                          [
                            recipe.subtitle1,
                            if (recipe.time != null) '${recipe.time} min'
                          ].where((s) => s != null).join(' • '),
                          style: textTheme.bodyMedium?.copyWith(
                            height: 1.3,
                            color: textTheme.bodySmall?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.rating, size: 18),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            recipe.rating?.toStringAsFixed(1) ?? 'c',
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
