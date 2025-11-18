import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class IntroControls extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int currentPage;
  final int pageCount;

  const IntroControls({
    super.key,
    required this.onNext,
    required this.onSkip,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onSkip,
            child: Text(
              'Skip',
              // ⬇️ Use theme text style
              style: AppTextStyles.button.copyWith(
                color: AppColors.primary,
                fontSize: 18,
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 56,
            // ⬇️ This button is AUTOMATICALLY styled by your app_theme.dart
            child: ElevatedButton(
              onPressed: onNext,
              // ⬇️ Use theme text style
              style: ElevatedButton.styleFrom(
                textStyle: AppTextStyles.button.copyWith(fontSize: 18),
              ),
              child: Text(
                currentPage == pageCount - 1 ? 'Start Cooking!' : 'Continue',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
