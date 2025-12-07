import 'package:cookit/data/models/list_item.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/services/recipe_service.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- STATE ---
class RecipeState extends Equatable {
  final Recipe recipe;
  final bool isFavorite;
  final bool nutritionExpanded;
  final List<IngredientItem> ingredients;

  const RecipeState({
    required this.recipe,
    this.isFavorite = false,
    required this.ingredients,
    this.nutritionExpanded = false,
  });

  bool get anyIngredientSelected => ingredients.any((item) => item.selected);

  RecipeState copyWith({
    Recipe? recipe,
    bool? isFavorite,
    bool? nutritionExpanded,
    List<IngredientItem>? ingredients,
  }) {
    return RecipeState(
      recipe: recipe ?? this.recipe,
      isFavorite: isFavorite ?? this.isFavorite,
      nutritionExpanded: nutritionExpanded ?? this.nutritionExpanded,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  @override
  List<Object?> get props =>
      [recipe, isFavorite, nutritionExpanded, ingredients];
}

// --- VIEWMODEL ---
class RecipeViewModel extends FamilyAsyncNotifier<RecipeState, int> {
  @override
  Future<RecipeState> build(int recipeId) async {
    final recipeService = ref.watch(recipeServiceProvider);
    final dbService = ref.watch(userDatabaseServiceProvider);

    // 1. Fetch recipe details
    final recipe = await recipeService.getRecipeDetails(recipeId);

    // 2. Check if it's already a favorite
    final isFav = await dbService.isFavoriteStream(recipeId).first;

    // 3. Fetch Pantry to do the matching
    final pantryList = await dbService.getListStream('pantry').first;

    // 4.Process Ingredients (Auto-select missing ones)
    // We create a modified list of ingredients where 'selected' status
    // is based on whether it is MISSING from the pantry.
    final processedIngredients = recipe.ingredients.map((ingredient) {
      // Simple Fuzzy Match: Check if pantry contains the ingredient name
      final isInPantry = pantryList.any((pantryItem) =>
          pantryItem.name
              .toLowerCase()
              .contains(ingredient.name.toLowerCase()) ||
          ingredient.name
              .toLowerCase()
              .contains(pantryItem.name.toLowerCase()));

      // If in pantry -> selected = false (Don't need to buy)
      // If NOT in pantry -> selected = true (Add to shopping list)
      return ingredient.copyWith(selected: !isInPantry);
    }).toList();

    return RecipeState(
      recipe: recipe,
      isFavorite: isFav,
      ingredients: processedIngredients, // Use our smart list
      nutritionExpanded: false,
    );
  }

  // --- ACTIONS ---

  Future<void> toggleFavorite() async {
    if (state.value == null) return;

    final currentStatus = state.value!.isFavorite;
    final recipe = state.value!.recipe;

    state = AsyncData(state.value!.copyWith(isFavorite: !currentStatus));

    try {
      await ref.read(userDatabaseServiceProvider).toggleFavorite(recipe);
    } catch (e) {
      state = AsyncData(state.value!.copyWith(isFavorite: currentStatus));
    }
  }

  void toggleNutrition(bool isExpanded) {
    if (state.value == null) return;
    state = AsyncData(state.value!.copyWith(nutritionExpanded: isExpanded));
  }

  void toggleIngredient(int index) {
    if (state.value == null) return;

    final currentIngredients = state.value!.ingredients;

    // Create a new list where the specific item at 'index' is toggled
    final newIngredients = currentIngredients.asMap().entries.map((entry) {
      final i = entry.key;
      final item = entry.value;

      if (i == index) {
        return item.copyWith(selected: !item.selected);
      }
      return item;
    }).toList();

    state = AsyncData(state.value!.copyWith(ingredients: newIngredients));
  }

  void clearSelections() {
    if (state.value == null) return;

    final newIngredients = state.value!.ingredients
        .map((item) => item.copyWith(selected: false))
        .toList();
    state = AsyncData(state.value!.copyWith(ingredients: newIngredients));
  }

  Future<int> addSelectedToShoppingList() async {
    if (state.value == null) return 0;

    final selectedItems =
        state.value!.ingredients.where((item) => item.selected).toList();

    if (selectedItems.isEmpty) return 0;

    final listItems = selectedItems
        .map((e) => ListItem(name: e.name, quantity: e.amount))
        .toList();

    final dbService = ref.read(userDatabaseServiceProvider);
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
