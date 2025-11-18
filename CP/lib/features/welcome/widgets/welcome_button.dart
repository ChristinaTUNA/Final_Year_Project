import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onPressed;

  const WelcomeButton({
    super.key,
    required this.animation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: SizedBox(
        width: 250,
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: AppBorders.allXxl,
            ),
            elevation: 0,
          ),
          child: Text(
            'Get Started',
            style: AppTextStyles.buttonLarge.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
