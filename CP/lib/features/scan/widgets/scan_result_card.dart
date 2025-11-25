import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/scanned_ingredient.dart';
import 'package:flutter/material.dart';

class ScanResultCard extends StatelessWidget {
  final ScannedIngredient ingredient;
  final VoidCallback? onDelete;

  const ScanResultCard({
    super.key,
    required this.ingredient,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppBorders.allMd,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Placeholder Icon/Image
          // Since Gemini gives text, we use a nice icon container
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant, // Generic food icon
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // 2. Ingredient Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              ingredient.name,
              style: textTheme.titleSmall, // 14px, w600
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 3. Category
          const SizedBox(height: 4),
          Text(
            ingredient.category,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textLightGray,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
