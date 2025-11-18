import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ChatbotSuggestionChip extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ChatbotSuggestionChip({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        padding: AppSpacing.pAllMd,
        decoration: const BoxDecoration(
          color: AppColors.backgroundNeutral,
          borderRadius: AppBorders.allMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
