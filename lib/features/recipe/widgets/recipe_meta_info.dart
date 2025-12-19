import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RecipeMetaInfo extends StatelessWidget {
  final String? time;
  final int servings;
  final String? tag1;
  final String? tag2;

  const RecipeMetaInfo({
    super.key,
    this.time,
    required this.servings,
    this.tag1,
    this.tag2,
  });

  @override
  Widget build(BuildContext context) {
    // Collect all data into a list
    final items = [
      if (time != null) {'icon': Icons.access_time_rounded, 'text': time!},
      {'icon': Icons.people_outline_rounded, 'text': '$servings Servings'},
      if (tag1 != null && tag1!.isNotEmpty)
        {'icon': Icons.label_outline_rounded, 'text': tag1!},
      if (tag2 != null && tag2!.isNotEmpty)
        {'icon': Icons.label_outline_rounded, 'text': tag2!},
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return _buildInfoChip(
            context, item['text'] as String, item['icon'] as IconData);
      }).toList(),
    );
  }

  Widget _buildInfoChip(BuildContext context, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20), // Pill shape
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrink to fit content
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                ),
          ),
        ],
      ),
    );
  }
}
