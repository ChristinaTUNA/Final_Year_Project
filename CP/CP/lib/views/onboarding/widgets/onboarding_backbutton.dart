import 'package:flutter/material.dart';

class OnboardingBackbutton extends StatelessWidget {
  final VoidCallback onPressed;
  const OnboardingBackbutton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: onPressed,
                tooltip: 'Back',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
