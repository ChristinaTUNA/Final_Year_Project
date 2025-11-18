import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/recipe_model.dart';
import 'package:equatable/equatable.dart';

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
    return _loadRecipes();
  }

  Future<HomeState> _loadRecipes() async {
    final jsonString =
        await rootBundle.loadString('assets/json/explore_recipes.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final recipes =
        jsonList.map((json) => Recipe.fromStaticJson(json)).toList();
    return HomeState(
      quickMeals: recipes,
      cookNowMeals: recipes.reversed.toList(),
    );
  }
}

// --- PROVIDER ---
final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);
