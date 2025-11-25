import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/recipe_model.dart';
import '../../../data/services/recipe_service.dart';

// --- STATE ---
class HomeState extends Equatable {
  final List<Recipe> quickMeals;
  final List<Recipe> cookNowMeals;

  const HomeState({
    this.quickMeals = const [],
    this.cookNowMeals = const [],
  });

  HomeState copyWith({
    List<Recipe>? quickMeals,
    List<Recipe>? cookNowMeals,
  }) {
    return HomeState(
      quickMeals: quickMeals ?? this.quickMeals,
      cookNowMeals: cookNowMeals ?? this.cookNowMeals,
    );
  }

  @override
  List<Object?> get props => [quickMeals, cookNowMeals];
}

// --- VIEWMODEL ---
class HomeViewModel extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    return _loadHomeData();
  }

  Future<HomeState> _loadHomeData() async {
    final recipeService = ref.watch(recipeServiceProvider);

    // 1. Try to load from Firebase Cache first (0 Points)
    List<Recipe> allRecipes = await recipeService.getCachedRecipes();

    // 2. Filter the list (whether from Cache or API) into sections
    // "Quick" = ready in 20 mins or less
    final quickMeals = allRecipes.where((r) {
      if (r.time == null) return false;
      // Parse "15 mins" or "45" to int
      final timeString = r.time!.replaceAll(RegExp(r'[^0-9]'), '');
      final minutes = int.tryParse(timeString) ?? 999;
      return minutes <= 20;
    }).toList();

    // TODO"Cook Now" = match things contains in the pantry list of user
    // TODO: also match user preference for suggesting recipe

    final cookNowMeals =
        allRecipes.where((r) => !quickMeals.contains(r)).toList();

    // TODO Fallback if there are no ingredient in their pantry but suggest quick and related to their preference

    if (cookNowMeals.isEmpty && quickMeals.isNotEmpty) {
      // cookNowMeals.addAll(quickMeals); // Optional: duplicate if needed
    }

    return HomeState(
      quickMeals: quickMeals,
      cookNowMeals: cookNowMeals,
    );
  }
}

// --- PROVIDER ---
final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
