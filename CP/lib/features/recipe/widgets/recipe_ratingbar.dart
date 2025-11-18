// lib/features/recipe/widgets/recipe_ratingbar.dart
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class RecipeRatingBar extends StatelessWidget {
  final double? rating;
  const RecipeRatingBar({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        ...List.generate(
          5,
          (i) => const Padding(
            padding: EdgeInsets.only(right: AppSpacing.xs),
            child: Icon(Icons.star, color: AppColors.rating),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          rating?.toStringAsFixed(1) ?? 'N/A',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.secondary),
        ),
      ],
    );
  }
}
