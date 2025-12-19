import 'package:flutter/material.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/features/shared/common_recipe_card.dart';

class ExploreRecipeGridCard extends StatelessWidget {
  final Recipe recipe;
  const ExploreRecipeGridCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return CommonRecipeCard(
      recipe: recipe,
      imageHeight: 120,
    );
  }
}
