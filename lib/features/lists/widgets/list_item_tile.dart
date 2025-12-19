import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../../../data/models/list_item.dart';

class ListItemTile extends StatelessWidget {
  final ListItem item;
  final VoidCallback onToggle;

  const ListItemTile({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDone = item.done;

    // Define colors based on state
    final textColor = isDone ? AppColors.textLightGray : AppColors.textDark;
    final decoration = isDone ? TextDecoration.lineThrough : null;

    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 2), // Small gap between items
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isDone ? Colors.transparent : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // 1. Animated Checkbox
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDone ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone ? AppColors.primary : AppColors.divider,
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),

              const SizedBox(width: AppSpacing.md),

              // 2. Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name
                    Text(
                      item.name,
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        color: textColor,
                        decoration: decoration,
                        decorationColor: AppColors.textLightGray,
                        fontWeight:
                            isDone ? FontWeight.normal : FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Quantity (Conditional)
                    if (item.quantity != null && item.quantity!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Qty: ${item.quantity}',
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            color: isDone
                                ? AppColors.textLightGray
                                : AppColors.primary,
                            fontWeight:
                                isDone ? FontWeight.normal : FontWeight.w600,
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
