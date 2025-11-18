import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_decoration.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../../../data/models/recipe_model.dart';

class HomeCookNowSection extends StatelessWidget {
  final Recipe? recipe;

  const HomeCookNowSection({super.key, this.recipe});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    if (recipe == null) {
      return Container(
        height: 200,
        decoration: AppDecorations.elevatedCardStyle.copyWith(
          color: theme.colorScheme.surface,
        ),
        child: const Center(child: Text('No "Cook Now" recipe available.')),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/recipe', arguments: recipe!.id);
      },
      child: Container(
        decoration: AppDecorations.elevatedCardStyle.copyWith(
          color: theme.scaffoldBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorders.radiusLg),
                topRight: Radius.circular(AppBorders.radiusLg),
              ),
              child: Image.asset(
                recipe!.image, // Use 'image'
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: AppSpacing.pAllMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe!.title, // Use 'title'
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Text(
                        '${recipe!.time ?? 'N/A'} • ⭐ ${recipe!.rating ?? 'N/A'}',
                        style: textTheme.bodyMedium?.copyWith(fontSize: 13),
                      ),
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
