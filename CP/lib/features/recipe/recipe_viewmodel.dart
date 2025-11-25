// lib/features/recipe/recipe_viewmodel.dart
import 'package:cookit/data/models/list_item.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/services/recipe_service.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- STATE ---
/// Holds all data and UI state for the RecipeScreen
class RecipeState extends Equatable {
  final Recipe recipe;
  final int servings;
  final bool nutritionExpanded;
  final List<IngredientItem> ingredients;

  const RecipeState({
    required this.recipe,
    required this.servings,
    required this.ingredients,
    this.nutritionExpanded = false,
  });

  // Helper getter to see if any ingredients are checked
  bool get anyIngredientSelected => ingredients.any((item) => item.selected);

  RecipeState copyWith({
    Recipe? recipe,
    int? servings,
    bool? nutritionExpanded,
    List<IngredientItem>? ingredients,
  }) {
    return RecipeState(
      recipe: recipe ?? this.recipe,
      servings: servings ?? this.servings,
      nutritionExpanded: nutritionExpanded ?? this.nutritionExpanded,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  @override
  List<Object?> get props => [recipe, servings, nutritionExpanded, ingredients];
}

// --- VIEWMODEL ---
class RecipeViewModel extends FamilyAsyncNotifier<RecipeState, int> {
  @override
  Future<RecipeState> build(int recipeId) async {
    // 1. Get the RecipeService
    final recipeService = ref.watch(recipeServiceProvider);

    // 2. Fetch the recipe (from cache or API)
    final recipe = await recipeService.getRecipeDetails(recipeId);

    // 3. Initialize and return the full state
    return RecipeState(
      recipe: recipe,
      servings: 2, // Default servings
      ingredients: recipe.ingredients,
      nutritionExpanded: false,
    );
  }

  // --- UI Logic Methods ---

  void incrementServings() {
    state = AsyncData(
      state.value!.copyWith(
        servings: state.value!.servings + 1,
      ),
    );
  }

  void decrementServings() {
    if (state.value!.servings > 1) {
      state = AsyncData(
        state.value!.copyWith(
          servings: state.value!.servings - 1,
        ),
      );
    }
  }

  void toggleNutrition(bool isExpanded) {
    state = AsyncData(
      state.value!.copyWith(
        nutritionExpanded: isExpanded,
      ),
    );
  }

  void toggleIngredient(int index) {
    // Create a new list of ingredients
    final newIngredients = List<IngredientItem>.from(state.value!.ingredients);

    // Get the specific ingredient
    final ingredient = newIngredients[index];

    // Update it
    newIngredients[index] = ingredient.copyWith(
      selected: !ingredient.selected,
    );

    // Update the state with the new list
    state = AsyncData(
      state.value!.copyWith(
        ingredients: newIngredients,
      ),
    );
  }

  void clearSelections() {
    final newIngredients = state.value!.ingredients
        .map((item) => item.copyWith(selected: false))
        .toList();

    state = AsyncData(
      state.value!.copyWith(
        ingredients: newIngredients,
      ),
    );
  }

  Future<int> addSelectedToShoppingList() async {
    final selectedItems =
        state.value!.ingredients.where((item) => item.selected).toList();

    if (selectedItems.isEmpty) return 0;

    // 1. Map to ListItems
    final listItems = selectedItems
        .map((e) => ListItem(name: e.name, quantity: e.amount))
        .toList();

    // 2. Access the Database Service directly
    final dbService = ref.read(userDatabaseServiceProvider);

    // 3. Add to Firestore (The ListsViewModel will automatically pick this up via stream)
    await dbService.addItems(listItems, 'shopping_list');
    clearSelections();

    return listItems.length;
  }
}

// --- PROVIDER ---
final recipeViewModelProvider =
    AsyncNotifierProvider.family<RecipeViewModel, RecipeState, int>(
  () => RecipeViewModel(),
);
