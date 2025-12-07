import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'home_recipecard.dart';

class HomeHorizontalSection extends StatelessWidget {
  final String title;
  final List<Recipe> recipes;

  const HomeHorizontalSection({
    super.key,
    required this.title,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    // If no recipes, hide the section entirely
    if (recipes.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: AppSpacing.pHorizontalLg,
          child: Text(
            title,
            style: textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Horizontal List
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: 8),
            itemCount: recipes.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              // Uses the standard fixed-width card
              return HomeRecipeCard(recipe: recipe);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
