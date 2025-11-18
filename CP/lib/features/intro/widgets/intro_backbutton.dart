import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class IntroBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const IntroBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        // ⬇️ Use theme spacing
        padding: const EdgeInsets.all(AppSpacing.lg), // 24px
        child: Align(
          alignment: Alignment.topLeft,
          // ⬇️ Removed redundant GestureDetector
          child: IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: onPressed,
            tooltip: 'Back',
            // ⬇️ Use theme color
            color: AppColors.white,
            // ⬇️ Use theme color
            highlightColor: AppColors.white.withValues(alpha: 0.2),
            splashColor: AppColors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
    );
  }
}
