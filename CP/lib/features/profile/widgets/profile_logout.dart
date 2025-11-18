import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyles.button.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w700,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.primary,
            shape: const RoundedRectangleBorder(borderRadius: AppBorders.allLg),
            elevation: 2,
          ),
          onPressed: onLogout,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Log Out',
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
