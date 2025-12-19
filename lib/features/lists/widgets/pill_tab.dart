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
    // Determine background color
    final backgroundColor = selected
        ? AppColors.primary
        : (light
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent);

    // Determine text color
    final textColor = selected ? Colors.white : AppColors.primary;

    final borderColor = (selected || light)
        ? Colors.transparent
        : AppColors.primary.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30), // Pill shape
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppTextStyles.labelLarge.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
