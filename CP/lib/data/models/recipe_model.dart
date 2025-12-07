/// A data model for a single ingredient item in a recipe.
class IngredientItem {
  final String name;
  final String amount;
  final String unit;
  final String? note;
  final bool selected;

  IngredientItem({
    required this.name,
    required this.amount,
    required this.unit,
    this.note,
    this.selected = false,
  });

  factory IngredientItem.fromSpoonacularJson(Map<String, dynamic> json) {
    return IngredientItem(
      name: json['nameClean'] ?? json['name'] ?? 'Unknown',
      amount: (json['amount'] ?? 0.0).toString(),
      unit: json['unit'] ?? '',
      note: json['originalName'] ?? json['original'] ?? '',
    );
  }

  IngredientItem copyWith({bool? selected}) {
    return IngredientItem(
      name: name,
      amount: amount,
      unit: unit,
      note: note,
      selected: selected ?? this.selected,
    );
  }
}

class InstructionStep {
  final int number;
  final String step;

  InstructionStep({required this.number, required this.step});

  factory InstructionStep.fromJson(Map<String, dynamic> json) {
    return InstructionStep(
      number: (json['number'] as num?)?.toInt() ?? 0,
      step: json['step'] as String? ?? '',
    );
  }
}

class InstructionSection {
  final String name;
  final List<InstructionStep> steps;

  InstructionSection({required this.name, required this.steps});

  factory InstructionSection.fromJson(Map<String, dynamic> json) {
    final stepsList = (json['steps'] as List<dynamic>?)
            ?.map((step) =>
                InstructionStep.fromJson(step as Map<String, dynamic>))
            .toList() ??
        [];

    return InstructionSection(
      name: json['name'] as String? ?? '',
      steps: stepsList,
    );
  }
}

/// A data model for a single recipe.
class Recipe {
  final int id;
  final String title;
  final String image;
  final double? rating;
  final String? time;
  final int? servings; // ⬇️ NEW FIELD
  final String? subtitle1;
  final String? subtitle2;
  final double? healthScore;
  final List<IngredientItem> ingredients;
  final List<InstructionSection> instructions;

  // Search-Specific Fields
  final int usedIngredientCount;
  final int missedIngredientCount;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    this.rating,
    this.time,
    this.servings, // ⬇️ ADDED
    this.subtitle1,
    this.subtitle2,
    this.healthScore,
    this.ingredients = const [],
    this.instructions = const [],
    this.usedIngredientCount = 0,
    this.missedIngredientCount = 0,
  });

  /// Factory constructor to parse static explore_recipes.json
  factory Recipe.fromStaticJson(Map<String, dynamic> json) {
    return Recipe(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? 'No Title',
      image: json['image'] ?? '',
      rating: (json['rating'] as num?)?.toDouble(),
      time: json['time'],
      servings: (json['servings'] as num?)?.toInt(), // ⬇️ PARSE
      subtitle1: json['subtitle1'],
      subtitle2: json['subtitle2'],
      healthScore: null,
      ingredients: [],
      instructions: [],
    );
  }

  /// Factory constructor to parse Spoonacular API response (Full Details)
  factory Recipe.fromSpoonacularJson(Map<String, dynamic> json) {
    final ingredients = (json['extendedIngredients'] as List<dynamic>?)
            ?.map((ing) =>
                IngredientItem.fromSpoonacularJson(ing as Map<String, dynamic>))
            .toList() ??
        [];

    final instructions = (json['analyzedInstructions'] as List<dynamic>?)
            ?.map((section) =>
                InstructionSection.fromJson(section as Map<String, dynamic>))
            .toList() ??
        [];

    return Recipe(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? 'No Title',
      image: json['image'] ?? '',
      rating: ((json['spoonacularScore'] as num?)?.toDouble() ?? 0.0) / 20.0,
      time: (json['readyInMinutes'] as int?)?.toString(),
      servings: (json['servings'] as num?)?.toInt(), // ⬇️ PARSE
      subtitle1: (json['diets'] as List<dynamic>?)?.firstOrNull,
      subtitle2: (json['dishTypes'] as List<dynamic>?)?.firstOrNull,
      healthScore: (json['healthScore'] as num?)?.toDouble(),
      ingredients: ingredients,
      instructions: instructions,
    );
  }

  /// Factory constructor to parse Spoonacular Search API response
  factory Recipe.fromSpoonacularSearchJson(Map<String, dynamic> json) {
    return Recipe(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? 'No Title',
      image: json['image'] ?? '',

      rating: ((json['spoonacularScore'] as num?)?.toDouble() ?? 0.0) / 20.0,

      time: json['readyInMinutes'] != null
          ? "${json['readyInMinutes']} mins"
          : null,

      // ⬇️ PARSE (Search results with addRecipeInformation=true include servings)
      servings: (json['servings'] as num?)?.toInt(),

      healthScore: (json['healthScore'] as num?)?.toDouble() ?? 0.0,

      usedIngredientCount: (json['usedIngredientCount'] as num?)?.toInt() ?? 0,
      missedIngredientCount:
          (json['missedIngredientCount'] as num?)?.toInt() ?? 0,

      subtitle1: null,
      subtitle2: null,
      ingredients: [],
      instructions: [],
    );
  }
}
