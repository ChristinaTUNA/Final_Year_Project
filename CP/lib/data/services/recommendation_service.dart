import 'package:cookit/data/models/list_item.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/models/user_preferences_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Helper object to store why a recipe got its score (for debugging/metrics)
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
  // Weights (Adjust these to tune your algorithm)
  // Example: Pantry Match is most important (50%)
  static const double _wPantry = 0.5;
  static const double _wPreference = 0.3;
  static const double _wTime = 0.2;

  /// The Core Function: Scores and Ranks a list of recipes
  List<Recipe> rankRecipes({
    required List<Recipe> recipes,
    required List<ListItem> pantryItems,
    required UserPreferences prefs,
    String mode = 'explore', // 'cook_now', 'quick', 'explore'
  }) {
    // 1. Calculate Scores for every recipe
    final scoredList = recipes.map((recipe) {
      final score = _calculateScore(recipe, pantryItems, prefs);
      return MapEntry(recipe, score);
    }).toList();

    // 2. Filter based on Mode (The Rules)
    var filtered = scoredList;

    if (mode == 'cook_now') {
      // Strict Rule: Must match at least 50% of pantry ingredients
      filtered = filtered.where((e) => e.value.pantryScore >= 0.5).toList();
    } else if (mode == 'quick') {
      // Strict Rule: Must be under 20 minutes
      filtered = filtered.where((e) {
        final mins = _parseMinutes(e.key.time);
        return mins > 0 && mins <= 20;
      }).toList();
    }

    // 3. Sort by Total Score (Highest score first)
    filtered.sort((a, b) => b.value.totalScore.compareTo(a.value.totalScore));

    // 4. Return the sorted recipes
    // (Optional: You could inject the missingIngredientCount back into the Recipe object here if you added that field)
    return filtered.map((e) => e.key).toList();
  }

  RecipeScore _calculateScore(
      Recipe recipe, List<ListItem> pantryItems, UserPreferences prefs) {
    // --- A. Pantry Match Score (0.0 to 1.0) ---
    double pantryScore = 0.0;
    int matches = 0;

    if (recipe.ingredients.isNotEmpty) {
      for (var ingredient in recipe.ingredients) {
        // Fuzzy match: Does "Red Onion" match "Onion" in pantry?
        final hasItem = pantryItems.any((pItem) =>
            pItem.name.toLowerCase().contains(ingredient.name.toLowerCase()) ||
            ingredient.name.toLowerCase().contains(pItem.name.toLowerCase()));

        if (hasItem) matches++;
      }
      pantryScore = matches / recipe.ingredients.length;
    }

    // --- B. Preference Match Score (0.0 to 1.0) ---
    double prefScore = 1.0;
    // Penalty: If user has a diet preference (e.g. Vegan) but recipe isn't tagged
    for (var diet in prefs.diets) {
      final tags = [recipe.subtitle1, recipe.subtitle2]
          .whereType<String>()
          .join(' ')
          .toLowerCase();
      // Simple check: does the subtitle contain the diet name?
      if (!tags.contains(diet.toLowerCase())) {
        prefScore -= 0.3; // -30% penalty
      }
    }
    if (prefScore < 0) prefScore = 0;

    // --- C. Time Score (0.0 to 1.0) ---
    double timeScore = 0.5; // Neutral default
    final mins = _parseMinutes(recipe.time);
    if (mins > 0) {
      // Simple logic: shorter is generally better score
      if (mins <= 20) {
        timeScore = 1.0; // Perfect
      } else if (mins <= 45) {
        timeScore = 0.7;
      } // Good
      else {
        timeScore = 0.3;
      } // Okay
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
      missingIngredientCount: recipe.ingredients.length - matches,
    );
  }

  int _parseMinutes(String? timeString) {
    if (timeString == null) return 0;
    // Extract numbers from "45 mins" -> 45
    final clean = timeString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean) ?? 0;
  }
}

// --- PROVIDER ---
final recommendationServiceProvider = Provider<RecommendationService>((ref) {
  return RecommendationService();
});
