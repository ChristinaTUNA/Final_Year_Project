import 'package:flutter/material.dart';
import '../../../models/onboarding_model.dart';

/// Displays image section of each onboarding page
class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.backgroundColor,
      alignment: data.alignment,
      child: Image.asset(
        data.imagePath,
        width: data.width,
        height: data.height,
      ),
    );
  }
}
