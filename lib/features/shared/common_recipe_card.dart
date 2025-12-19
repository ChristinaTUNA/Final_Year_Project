import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:flutter/material.dart';

class CommonRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final double imageHeight;
  final bool showPantryBadges;

  const CommonRecipeCard({
    super.key,
    required this.recipe,
    this.imageHeight = 160,
    this.showPantryBadges = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final bgColor = theme.brightness == Brightness.light
        ? AppColors.background
        : AppColors.cardBackgroundDark;

    // Logic: Only show pantry match if data exists AND we asked for it
    final bool isPantryMatch = showPantryBadges &&
        (recipe.usedIngredientCount > 0 || recipe.missedIngredientCount > 0);

    // Logic: Show details if we have them (Time/Rating)
    final bool hasDetails = recipe.time != null || recipe.rating != null;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/recipe', arguments: recipe.id);
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16), // Softer corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06), // Very subtle shadow
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- 1. Image Section ---
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Hero(
                    tag: 'recipe_image_${recipe.id}',
                    child: Image.network(
                      recipe.image,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        height: imageHeight,
                        width: double.infinity,
                        color: AppColors.backgroundNeutral,
                        child: Icon(Icons.broken_image_rounded,
                            color: Colors.grey[400], size: 32),
                      ),
                    ),
                  ),

                  // SMART BADGE (Top Right)
                  if (isPantryMatch)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: recipe.missedIngredientCount == 0
                              ? Colors.green.withValues(alpha: 0.9)
                              : AppColors.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20), // Pill shape
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              recipe.missedIngredientCount == 0
                                  ? Icons.check_circle
                                  : Icons.shopping_bag_outlined,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              recipe.missedIngredientCount == 0
                                  ? 'All Items'
                                  : 'Missing ${recipe.missedIngredientCount}',
                              style: textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // --- 2. Content Section ---
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // --- DYNAMIC FOOTER ---

                  // CASE A: Pantry Match (Detailed Status)
                  if (isPantryMatch)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "You have X items"
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.inventory_2_outlined,
                                  size: 12, color: Colors.green),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'You have ${recipe.usedIngredientCount} items',
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // "View Recipe" Action
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'View Recipe  ›',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )

                  // CASE B: Standard View (Time & Rating)
                  else if (hasDetails)
                    Row(
                      children: [
                        // Time Pill (Only if time is available)
                        if (recipe.time != null)
                          _buildMetaPill(
                            context,
                            icon: Icons.access_time_rounded,
                            text: recipe.time!,
                            color: Colors.grey[700]!,
                          ),

                        const Spacer(), // Push rating to end

                        // Rating Star
                        if (recipe.rating != null)
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Color(0xFFFFC107), size: 18),
                              const SizedBox(width: 2),
                              Text(
                                recipe.rating!.toStringAsFixed(1),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              )
                            ],
                          )
                      ],
                    )

                  // CASE C: Lite View (Fallback)
                  else
                    Row(
                      children: [
                        Text(
                          'Tap for details',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textLightGray,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_rounded,
                            size: 18,
                            color: AppColors.primary.withValues(alpha: 0.5)),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetaPill(BuildContext context,
      {required IconData icon, required String text, required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
