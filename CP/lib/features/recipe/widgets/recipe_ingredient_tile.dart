import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/recipe_model.dart';
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
    final isNeedToBuy = ingredient.selected;
    final isAlreadyHave = !ingredient.selected;

    final bool showAmount = ingredient.amount.isNotEmpty &&
        ingredient.amount != '0' &&
        ingredient.amount != '0.0';

    final bool showNote =
        ingredient.note != null && ingredient.note!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          // Subtle background to highlight "To Buy" items
          decoration: BoxDecoration(
            color: isNeedToBuy
                ? AppColors.primary.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox Logic
              // Checked (Red) = Will add to shopping list
              // Unchecked (Grey/Green) = Already have it
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isNeedToBuy ? AppColors.primary : Colors.white,
                  border: Border.all(
                    color: isNeedToBuy
                        ? AppColors.primary
                        : (isAlreadyHave ? Colors.green : AppColors.divider),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: isNeedToBuy
                    ? const Icon(Icons.shopping_cart,
                        size: 14, color: Colors.white)
                    : (isAlreadyHave
                        ? const Icon(Icons.check, size: 14, color: Colors.green)
                        : null),
              ),

              const SizedBox(width: AppSpacing.md),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ingredient.name,
                            style: textTheme.titleSmall?.copyWith(
                              // GREEN if we have it, BLACK if we need it
                              color: isAlreadyHave
                                  ? Colors.green
                                  : AppColors.textDark,
                              fontWeight: FontWeight.w600,
                              decoration:
                                  isAlreadyHave ? TextDecoration.none : null,
                            ),
                          ),
                        ),
                        if (showAmount) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${ingredient.amount} ${ingredient.unit}'.trim(),
                            style: textTheme.titleSmall?.copyWith(
                              color: isAlreadyHave
                                  ? Colors.green
                                  : AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (showNote)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          ingredient.note!,
                          style: textTheme.bodySmall?.copyWith(
                            color: isAlreadyHave
                                ? Colors.green.withValues(alpha: 0.8)
                                : AppColors.textLightGray,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
