import 'package:cookit/core/theme/app_colors.dart';
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

    // Logic:
    // selected = true  -> NEED TO BUY (Show Add Icon)
    // selected = false -> HAVE IT (Show Check Icon)
    final isNeedToBuy = ingredient.selected;
    final isAlreadyHave = !ingredient.selected;

    final bool showAmount = ingredient.amount.isNotEmpty &&
        ingredient.amount != '0' &&
        ingredient.amount != '0.0';

    final bool showNote =
        ingredient.note != null && ingredient.note!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isNeedToBuy
                ? Colors.white
                : Colors.green
                    .withValues(alpha: 0.08), // Subtle green bg for 'Have'
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isNeedToBuy
                  ? Colors.grey.shade200
                  : Colors.green.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: isNeedToBuy
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              // 1. Content (Left)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Amount
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            ingredient.name,
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isAlreadyHave
                                  ? Colors.green[800]
                                  : AppColors.textDark,
                              decoration: isAlreadyHave
                                  ? TextDecoration
                                      .none // Clean look is better than strikethrough
                                  : null,
                            ),
                          ),
                        ),
                        if (showAmount) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${ingredient.amount} ${ingredient.unit}'.trim(),
                            style: textTheme.bodyMedium?.copyWith(
                              color: isAlreadyHave
                                  ? Colors.green[700]
                                  : AppColors.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Note (Subtitle)
                    if (showNote)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          ingredient.note!,
                          style: textTheme.bodySmall?.copyWith(
                            color: isAlreadyHave
                                ? Colors.green[600]
                                : AppColors.textLightGray,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // 2. Action Button (Right)
              // This is cleaner than a checkbox on the left
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isNeedToBuy ? Colors.grey.shade100 : Colors.green,
                  shape: BoxShape.circle,
                  border: isNeedToBuy
                      ? Border.all(color: Colors.grey.shade300)
                      : null,
                ),
                child: Icon(
                  isNeedToBuy ? Icons.add : Icons.check,
                  size: 18,
                  color: isNeedToBuy ? AppColors.textGray : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
