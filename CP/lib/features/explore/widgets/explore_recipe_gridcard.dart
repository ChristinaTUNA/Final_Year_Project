import 'package:flutter/material.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/features/shared/common_recipe_card.dart'; // Import Shared

class ExploreRecipeGridCard extends StatelessWidget {
  final Recipe recipe;
  const ExploreRecipeGridCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // The GridView parent controls the width/height,
    // so we just pass the recipe and internal image preference.
    return CommonRecipeCard(
      recipe: recipe,
      imageHeight: 170, // Smaller image for grid
    );
  }
}
