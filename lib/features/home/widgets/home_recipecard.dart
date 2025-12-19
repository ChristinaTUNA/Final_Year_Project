import 'package:cookit/features/shared/common_recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:cookit/data/models/recipe_model.dart';

class HomeRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool showPantryBadges;

  const HomeRecipeCard({
    super.key,
    required this.recipe,
    this.showPantryBadges = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: CommonRecipeCard(
        recipe: recipe,
        imageHeight: 160,
        showPantryBadges: showPantryBadges,
      ),
    );
  }
}
