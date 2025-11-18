import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import '../../../data/models/list_item.dart';

class ListItemTile extends StatelessWidget {
  final ListItem item;
  final VoidCallback onToggle; // callback to toggle done
  const ListItemTile({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textBodyStyle = textTheme.bodyLarge?.copyWith(
      fontSize: 16, // Override theme's default 14px
      color: item.done ? AppColors.textLightGray : textTheme.bodyLarge?.color,
      decoration: item.done ? TextDecoration.lineThrough : null,
    );

    final textSubtitleStyle = textTheme.bodyMedium?.copyWith(
      fontSize: 13, // Override theme's default 14px
    );

    return InkWell(
      onTap: onToggle,
      child: Row(
        children: [
          // Checkbox circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.done ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: item.done ? AppColors.primary : AppColors.divider,
                width: 2,
              ),
            ),
            child: item.done
                ? const Icon(Icons.check, size: 18, color: AppColors.white)
                : null,
          ),

          const SizedBox(width: AppSpacing.sm),

          // Item name
          Expanded(
            child: Text(
              item.name,
              style: textBodyStyle,
            ),
          ),

          // Optional quantity/brand
          if (item.quantity != null || item.brand != null)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: Text(
                '${item.quantity ?? ''}${item.brand != null ? ' · ${item.brand}' : ''}',
                style: textSubtitleStyle,
              ),
            ),
        ],
      ),
    );
  }
}
