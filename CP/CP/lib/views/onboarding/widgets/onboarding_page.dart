import 'package:flutter/material.dart';
import '../../../models/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            data.imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
