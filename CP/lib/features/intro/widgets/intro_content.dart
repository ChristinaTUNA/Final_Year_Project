import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../../../data/models/intro_model.dart';

class IntroContent extends StatelessWidget {
  final IntroData data;

  const IntroContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: textTheme.displayLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 16, // Override to 16px
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
