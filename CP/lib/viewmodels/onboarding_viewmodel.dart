import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/onboarding_model.dart';

/// controls the current onboarding page index
class OnboardingViewModel extends StateNotifier<int> {
  OnboardingViewModel() : super(0);

  final List<OnboardingData> pages = [
    OnboardingData(
      title: 'Scan Ingredients,\nDiscover Recipes',
      description:
          'Transform random ingredients into amazing\nmeals with one simple photo',
      imagePath: 'assets/images/onboarding_1.webp',
      backgroundColor: Colors.white,
    ),
    OnboardingData(
      title: 'Make Home Cooking\nFeel Effortless',
      description:
          'AI instantly matches your pantry items\nwith thousands of delicious recipes',
      imagePath: 'assets/images/onboarding_2.jpg',
      backgroundColor: Colors.white,
    ),
    OnboardingData(
      title: 'Shop Smarter, Not Harder\nEvery Time',
      description:
          'Get organized grocery lists showing\nexactly what ingredients you\'re missing',
      imagePath: 'assets/images/onboarding_3.jpg',
      backgroundColor: Colors.white,
    ),
  ];

  void setPage(int index) => state = index;
  void nextPage() => state++;
  void skipToEnd() => state = pages.length - 1;
}

final onboardingProvider =
    StateNotifierProvider<OnboardingViewModel, int>((ref) {
  return OnboardingViewModel();
});
