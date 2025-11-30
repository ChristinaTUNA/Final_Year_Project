// lib/features/recipe/widgets/recipe_ingredient_tile.dart
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/recipe_model.dart'; // Assuming this is the path
import 'package:flutter/material.dart';

class RecipeIngredientTile extends StatelessWidget {
  final IngredientItem ingredient;
  final VoidCallback onToggle;

  const RecipeIngredientTile({
    super.key,
    required this.ingredient,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Checkbox(
            value: ingredient.selected,
            onChanged: (_) => onToggle(),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ingredient.name,
                        style: textTheme.titleSmall,
                      ),
                    ),
                    Text(
                      ingredient.amount,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  ingredient.note,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textLightGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
