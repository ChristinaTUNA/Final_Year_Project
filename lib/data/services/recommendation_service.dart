import 'package:cookit/data/models/list_item.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/models/user_preferences_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeScore {
  final double totalScore;
  final double pantryScore;
  final double preferenceScore;
  final double timeScore;
  final int missingIngredientCount;

  RecipeScore({
    required this.totalScore,
    required this.pantryScore,
    required this.preferenceScore,
    required this.timeScore,
    required this.missingIngredientCount,
  });
}

class RecommendationService {
  static const double _wPantry = 0.5;
  static const double _wPreference = 0.3;
  static const double _wTime = 0.2;

  List<Recipe> rankRecipes({
    required List<Recipe> recipes,
    required List<ListItem> pantryItems,
    required UserPreferences prefs,
    String mode = 'explore',
  }) {
    final scoredList = recipes.map((recipe) {
      final score = _calculateScore(recipe, pantryItems, prefs);
      return MapEntry(recipe, score);
    }).toList();

    var filtered = scoredList;

    if (mode == 'cook_now') {
      filtered = filtered.where((e) => e.value.pantryScore >= 0.3).toList();
    } else if (mode == 'quick') {
      filtered = filtered.where((e) {
        final mins = _parseMinutes(e.key.time);
        return mins > 0 && mins <= 20;
      }).toList();
    }

    if (mode != 'recent') {
      filtered.sort((a, b) => b.value.totalScore.compareTo(a.value.totalScore));
    }

    return filtered.map((e) => e.key).toList();
  }

  List<Recipe> getDietaryMatches(List<Recipe> recipes, String diet) {
    return recipes.where((r) {
      final tags = [r.title, r.subtitle1, r.subtitle2]
          .whereType<String>()
          .join(' ')
          .toLowerCase();
      return tags.contains(diet.toLowerCase());
    }).toList();
  }

  RecipeScore _calculateScore(
      Recipe recipe, List<ListItem> pantryItems, UserPreferences prefs) {
    // --- A. Pantry Match Score ---
    double pantryScore = 0.0;
    int missingCount = 0; // Default

    if (recipe.usedIngredientCount > 0 || recipe.missedIngredientCount > 0) {
      final totalIngredients =
          recipe.usedIngredientCount + recipe.missedIngredientCount;
      if (totalIngredients > 0) {
        pantryScore = recipe.usedIngredientCount / totalIngredients;
        missingCount = recipe.missedIngredientCount;
      }
    }
    // Fallback: Manual calculation for cached recipes
    else if (recipe.ingredients.isNotEmpty) {
      int matches = 0;
      for (var ingredient in recipe.ingredients) {
        final hasItem = pantryItems.any((pItem) =>
            pItem.name.toLowerCase().contains(ingredient.name.toLowerCase()) ||
            ingredient.name.toLowerCase().contains(pItem.name.toLowerCase()));
        if (hasItem) matches++;
      }
      pantryScore = matches / recipe.ingredients.length;
      missingCount = recipe.ingredients.length - matches;
    }

    // --- B. Preference Match Score ---
    double prefScore = 1.0;
    for (var diet in prefs.diets) {
      final tags = [recipe.subtitle1, recipe.subtitle2]
          .whereType<String>()
          .join(' ')
          .toLowerCase();
      // If recipe has no tags (lite version), we don't punish it yet
      if (tags.isNotEmpty && !tags.contains(diet.toLowerCase())) {
        prefScore -= 0.3;
      }
    }
    if (prefScore < 0) prefScore = 0;

    // --- C. Time Score ---
    double timeScore = 0.5;
    final mins = _parseMinutes(recipe.time);
    if (mins > 0) {
      if (mins <= 20) {
        timeScore = 1.0;
      } else if (mins <= 45) {
        timeScore = 0.7;
      } else {
        timeScore = 0.3;
      }
    }

    // --- FINAL WEIGHTED SCORE ---
    final total = (pantryScore * _wPantry) +
        (prefScore * _wPreference) +
        (timeScore * _wTime);

    return RecipeScore(
      totalScore: total,
      pantryScore: pantryScore,
      preferenceScore: prefScore,
      timeScore: timeScore,
      missingIngredientCount: missingCount,
    );
  }

  int _parseMinutes(String? timeString) {
    if (timeString == null) return 0;
    final clean = timeString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean) ?? 0;
  }
}

final recommendationServiceProvider = Provider<RecommendationService>((ref) {
  return RecommendationService();
});
