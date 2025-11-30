// lib/features/home/widgets/home_recipecard.dart
import 'package:flutter/material.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/features/shared/common_recipe_card.dart'; // Import Shared

class HomeRecipeCard extends StatelessWidget {
  final Recipe recipe;

  const HomeRecipeCard({super.key, required this.recipe});
//TODO: subtitle 1 & 2
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210, // Fixed width for horizontal list
      child: CommonRecipeCard(
        recipe: recipe,
        imageHeight: 160, // Specific height for Quick Meals
      ),
    );
  }
}
