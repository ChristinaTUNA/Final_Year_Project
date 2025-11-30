import 'package:cookit/data/models/user_preferences_model.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- STATE ---
@immutable
class PreferenceState {
  final int currentPage;
  final Set<String> dietaryPrefs;
  final String? timePref;
  final Set<String> servingsPref;
  final bool isLoading; // ⬇️ Added loading state

  const PreferenceState({
    this.currentPage = 0,
    this.dietaryPrefs = const {},
    this.timePref,
    this.servingsPref = const {},
    this.isLoading = false,
  });

  PreferenceState copyWith({
    int? currentPage,
    Set<String>? dietaryPrefs,
    String? timePref,
    Set<String>? servingsPref,
    bool? isLoading,
  }) {
    return PreferenceState(
      currentPage: currentPage ?? this.currentPage,
      dietaryPrefs: dietaryPrefs ?? this.dietaryPrefs,
      timePref: timePref ?? this.timePref,
      servingsPref: servingsPref ?? this.servingsPref,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// --- VIEWMODEL ---
class PreferenceViewModel extends StateNotifier<PreferenceState> {
  final UserDatabaseService _dbService;

  // ⬇️ Inject the database service
  PreferenceViewModel(this._dbService) : super(const PreferenceState());

  // --- ACTIONS ---

  // 1. Load data (For "Edit Preferences" Screen)
  Future<void> loadExistingPreferences() async {
    state = state.copyWith(isLoading: true);
    try {
      final prefs = await _dbService.getPreferences();
      state = state.copyWith(
        dietaryPrefs: prefs.diets,
        timePref: prefs.timePreference,
        servingsPref: prefs.servings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // 2. Save data (For both Onboarding & Edit Screen)
  Future<void> savePreferences() async {
    state = state.copyWith(isLoading: true);
    try {
      final prefs = UserPreferences(
        diets: state.dietaryPrefs,
        timePreference: state.timePref ?? '30-60 min', // Default if skipped
        servings: state.servingsPref.isEmpty ? {'Just me'} : state.servingsPref,
      );

      await _dbService.savePreferences(prefs);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Ideally handle error (show snackbar in UI)
    }
  }

  // --- UI LOGIC ---

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void toggleDietaryPref(String pref) {
    final currentPrefs = Set<String>.from(state.dietaryPrefs);
    if (pref == 'No preferences') {
      currentPrefs.clear();
      currentPrefs.add(pref);
    } else {
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
    // For servings, we usually want single selection, but Set is fine
    // If you want single select logic:
    state = state.copyWith(servingsPref: {pref});
  }

  // --- NAVIGATION LOGIC ---

  Future<void> skip(BuildContext context) async {
    // Save defaults (or current selection) to Firebase before leaving
    await savePreferences();

    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  Future<void> next(BuildContext context, PageController controller) async {
    if (state.currentPage == 2) {
      // Last page: Save and Finish
      await skip(context);
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
      Navigator.of(context).pop();
    } else {
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

// --- PROVIDER ---
final preferenceViewModelProvider =
    StateNotifierProvider<PreferenceViewModel, PreferenceState>((ref) {
  // ⬇️ Get the DB Service from the provider tree
  final dbService = ref.watch(userDatabaseServiceProvider);
  return PreferenceViewModel(dbService);
});
