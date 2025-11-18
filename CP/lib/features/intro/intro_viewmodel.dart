import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/intro_model.dart';

// --- STATE ---
class IntroState {
  final int currentPage;
  final List<IntroData> pages;

  const IntroState({
    this.currentPage = 0,
    this.pages = const [],
  });

  IntroState copyWith({int? currentPage}) {
    return IntroState(
      currentPage: currentPage ?? this.currentPage,
      pages: pages,
    );
  }
}

// --- VIEWMODEL ---
class IntroViewModel extends StateNotifier<IntroState> {
  IntroViewModel() : super(const IntroState(currentPage: 0, pages: _introData));

  static const List<IntroData> _introData = [
    IntroData(
      title: 'Scan Ingredients,\nDiscover Recipes',
      description:
          'Transform random ingredients into amazing\nmeals with one simple photo',
      imagePath: 'assets/images/onboarding_1.webp',
    ),
    IntroData(
      title: 'Make Home Cooking\nFeel Effortless',
      description:
          'AI instantly matches your pantry items\nwith thousands of delicious recipes',
      imagePath: 'assets/images/onboarding_2.jpg',
    ),
    IntroData(
      title: 'Shop Smarter, Not Harder\nEvery Time',
      description:
          'Get organized grocery lists showing\nexactly what ingredients you\'re missing',
      imagePath: 'assets/images/onboarding_3.jpg',
    ),
  ];

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void onBackButtonPressed(BuildContext context, PageController controller) {
    if (state.currentPage == 0) {
      // On the first page, pop back to the previous screen (e.g., Welcome)
      Navigator.of(context).pop();
    } else {
      // Go to the previous page
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void onNextButtonPressed(BuildContext context, PageController controller) {
    if (state.currentPage < state.pages.length - 1) {
      // Go to the next page
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      // On the last page, navigate to Login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void onSkipButtonPressed(BuildContext context, PageController controller) {
    // Animate to the last page
    controller.animateToPage(
      state.pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

// --- PROVIDER ---
final introViewModelProvider =
    StateNotifierProvider<IntroViewModel, IntroState>(
  (ref) => IntroViewModel(),
);
