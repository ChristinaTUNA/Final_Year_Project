import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RecipeMetaInfo extends StatelessWidget {
  final String? time;
  final int? servings;
  final String? tag1;
  final String? tag2;

  const RecipeMetaInfo({
    super.key,
    this.time,
    this.servings,
    this.tag1,
    this.tag2,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // 1. Build the list of text parts
    final parts = <String>[];

    // Add Servings
    parts.add('$servings Servings');

    // Add Tags
    if (tag1 != null && tag1!.isNotEmpty) parts.add(tag1!);
    if (tag2 != null && tag2!.isNotEmpty) parts.add(tag2!);

    // Join them with the bullet point
    final textString = parts.join(' • ');

    // If we have absolutely no info, hide
    if (time == null && textString.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrink to fit content
        children: [
          // 2. The Time Icon + Time Text
          if (time != null) ...[
            const Icon(
              Icons.access_time_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              time!,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Add a separator if there is more text coming
            if (textString.isNotEmpty)
              Text(
                ' • ',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],

          // 3. The Rest of the Info
          if (textString.isNotEmpty)
            Flexible(
              child: Text(
                textString,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
