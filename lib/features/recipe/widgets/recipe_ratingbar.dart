import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class RecipeRatingBar extends StatelessWidget {
  final double? rating;
  final double iconSize;

  const RecipeRatingBar({
    super.key,
    required this.rating,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Default to 0.0 if null
    final effectiveRating = rating ?? 0.0;

    return Row(
      children: [
        // Generate 5 stars dynamically
        ...List.generate(5, (index) {
          final starPosition = index + 1;
          IconData iconData;
          Color iconColor;

          if (effectiveRating >= starPosition) {
            // Full Star
            iconData = Icons.star_rounded;
            iconColor = AppColors.rating; // Gold/Amber
          } else if (effectiveRating >= starPosition - 0.5) {
            // Half Star
            iconData = Icons.star_half_rounded;
            iconColor = AppColors.rating;
          } else {
            // Empty Star
            iconData = Icons.star_border_rounded;
            iconColor = Colors.grey.shade300; // Greyed out
          }

          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Icon(
              iconData,
              color: iconColor,
              size: iconSize,
            ),
          );
        }),

        const SizedBox(width: AppSpacing.sm),

        // Text Value
        Text(
          effectiveRating > 0 ? effectiveRating.toStringAsFixed(1) : 'N/A',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
