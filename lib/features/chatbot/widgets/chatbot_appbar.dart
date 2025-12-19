import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ChatbotAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onMenuPressed;

  const ChatbotAppBar({
    super.key,
    required this.onBackPressed,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,

      // 1. Modern Back Button
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            size: 20, color: AppColors.textDark),
        onPressed: onBackPressed,
      ),

      // 2. Title with Badge
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Chef Mato', // Matches your AI Persona
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 8),

          // AI Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2), width: 1),
            ),
            child: const Text(
              'AI',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),

      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textDark),
          onPressed: onMenuPressed,
        ),
        const SizedBox(width: AppSpacing.sm),
      ],

      // 3. Subtle Separation Line
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: AppColors.divider,
          height: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
