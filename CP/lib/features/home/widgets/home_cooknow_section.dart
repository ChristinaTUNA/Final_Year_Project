import 'package:cookit/core/theme/app_decoration.dart';
import 'package:flutter/material.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/features/shared/common_recipe_card.dart'; // Import Shared../../shared/widgets/common_recipe_card.dart'; // Import Shared

class HomeCookNowSection extends StatelessWidget {
  final Recipe? recipe;

  const HomeCookNowSection({super.key, this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (recipe == null) {
      return Container(
        height: 200,
        decoration: AppDecorations.elevatedCardStyle.copyWith(
          color: theme.colorScheme.surface,
        ),
        child: const Center(
            child: Text('No Ingredients in your pantry to cook now.')),
      );
    }
//
    return CommonRecipeCard(
      recipe: recipe!,
      imageHeight: 200, // Larger hero image for Cook Now
    );
  }
}
