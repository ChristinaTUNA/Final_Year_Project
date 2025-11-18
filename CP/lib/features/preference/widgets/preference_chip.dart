import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class PreferenceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PreferenceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.background;
    final textColor = isSelected ? AppColors.white : AppColors.primary;

    final textStyle = AppTextStyles.button.copyWith(
      color: textColor,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, // 16px
          vertical: AppSpacing.sm, // 12px
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppBorders.pill,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.white,
                size: 20,
              ),
            if (isSelected) const SizedBox(width: AppSpacing.sm),
            Text(label, style: textStyle),
          ],
        ),
      ),
    );
  }
}
