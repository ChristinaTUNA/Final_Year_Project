import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/onboarding_model.dart';

final onboardingProvider =
    NotifierProvider<OnboardingViewModel, int>(OnboardingViewModel.new);

class OnboardingViewModel extends Notifier<int> {
  @override
  int build() => 0;

  final List<OnboardingData> pages = const [
    OnboardingData(
      title: 'Scan Ingredients,\nDiscover Recipes',
      description:
          'Transform random ingredients into amazing\nmeals with one simple photo',
      imagePath: 'assets/images/onboarding_1.webp',
    ),
    OnboardingData(
      title: 'Make Home Cooking\nFeel Effortless',
      description:
          'AI instantly matches your pantry items\nwith thousands of delicious recipes',
      imagePath: 'assets/images/onboarding_2.jpg',
    ),
    OnboardingData(
      title: 'Shop Smarter, Not Harder\nEvery Time',
      description:
          'Get organized grocery lists showing\nexactly what ingredients you\'re missing',
      imagePath: 'assets/images/onboarding_3.jpg',
    ),
  ];
  void onBackPressed(PageController controller) {
    if (state > 0) {
      state--;
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void nextPage() {
    if (state < pages.length - 1) state++;
  }

  void skipToEnd() => state = pages.length - 1;

  void setPage(int index) => state = index;
}
