import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class PillTab extends StatelessWidget {
  final String label;
  final bool selected;
  final bool light;
  final VoidCallback onTap;

  const PillTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyles.labelLarge.copyWith(
      color: selected ? AppColors.white : AppColors.primary,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (light ? AppColors.primaryLight : Colors.transparent),
          borderRadius: AppBorders.pill,
        ),
        child: Text(
          label,
          style: textStyle,
        ),
      ),
    );
  }
}
