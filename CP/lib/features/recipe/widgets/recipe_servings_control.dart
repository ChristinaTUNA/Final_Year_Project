import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class RecipeServingsControl extends StatelessWidget {
  final int servings;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const RecipeServingsControl({
    super.key,
    required this.servings,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle_outline,
              color: AppColors.textLightGray),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: AppBorders.allSm,
            border: Border.all(color: AppColors.divider),
          ),
          child: Text(
            '$servings',
            style: textTheme.titleSmall,
          ),
        ),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle_outline,
              color: AppColors.textLightGray),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Servings',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
