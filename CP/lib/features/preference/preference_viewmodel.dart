import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- STATE ---
/// Holds the state for the multi-step onboarding process.
@immutable
class PreferenceState {
  final int currentPage;
  final Set<String> dietaryPrefs;
  final String? timePref;
  final Set<String> servingsPref;

  const PreferenceState({
    this.currentPage = 0,
    this.dietaryPrefs = const {},
    this.timePref,
    this.servingsPref = const {},
  });

  PreferenceState copyWith({
    int? currentPage,
    Set<String>? dietaryPrefs,
    String? timePref,
    Set<String>? servingsPref,
  }) {
    return PreferenceState(
      currentPage: currentPage ?? this.currentPage,
      dietaryPrefs: dietaryPrefs ?? this.dietaryPrefs,
      timePref: timePref ?? this.timePref,
      servingsPref: servingsPref ?? this.servingsPref,
    );
  }
}

// --- VIEWMODEL ---
/// Manages the logic and state for the multi-step onboarding flow.
class PreferenceViewModel extends StateNotifier<PreferenceState> {
  PreferenceViewModel() : super(const PreferenceState());

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void toggleDietaryPref(String pref) {
    final currentPrefs = Set<String>.from(state.dietaryPrefs);
    if (pref == 'No preferences') {
      // If "No preferences" is tapped, it becomes the only selection
      currentPrefs.clear();
      currentPrefs.add(pref);
    } else {
      // If any other pref is tapped, remove "No preferences"
      currentPrefs.remove('No preferences');
      if (currentPrefs.contains(pref)) {
        currentPrefs.remove(pref);
      } else {
        currentPrefs.add(pref);
      }
    }
    state = state.copyWith(dietaryPrefs: currentPrefs);
  }

  void setTimePref(String pref) {
    state = state.copyWith(timePref: pref);
  }

  void toggleServingsPref(String pref) {
    final currentPrefs = Set<String>.from(state.servingsPref);
    if (currentPrefs.contains(pref)) {
      currentPrefs.remove(pref);
    } else {
      currentPrefs.add(pref);
    }
    state = state.copyWith(servingsPref: currentPrefs);
  }

  void skip(BuildContext context) {
    // Navigate to home and remove all routes behind
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  void next(BuildContext context, PageController controller) {
    if (state.currentPage == 2) {
      // This is the last page, finish and go to home
      skip(context);
    } else {
      // Go to the next page
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void back(BuildContext context, PageController controller) {
    if (state.currentPage == 0) {
      // We are on the first page, pop back to login/welcome
      Navigator.of(context).pop();
    } else {
      // Go to the previous page
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

// --- PROVIDER ---
final preferenceProvider =
    StateNotifierProvider<PreferenceViewModel, PreferenceState>(
  (ref) => PreferenceViewModel(),
);
