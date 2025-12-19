import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'profile_tile.dart';

class ProfileMenuList extends StatelessWidget {
  final void Function(String) onPushPlaceholder;
  final bool isAnonymous;

  const ProfileMenuList({
    super.key,
    required this.onPushPlaceholder,
    required this.isAnonymous,
  });

  // 1. Centralized Navigation Logic
  void _handleRestrictedTap(BuildContext context, String routeName) {
    if (isAnonymous) {
      _showLoginDialog(context);
    } else {
      Navigator.of(context).pushNamed(routeName);
    }
  }

  // 2. Enhanced Dialog
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Login Required'),
        content: const Text(
          'Please login to save your preferences and favorite recipes securely.',
          style: TextStyle(height: 1.5),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Login Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.brightness == Brightness.light
        ? AppColors.background
        : theme.colorScheme.surface;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppBorders.allLg,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          // --- Section 1: Personalization (Restricted) ---
          ProfileTile(
            icon: Icons.tune_rounded,
            label: 'My Preferences',
            onTap: () => _handleRestrictedTap(context, '/my_preferences'),
          ),
          const _MenuDivider(),

          ProfileTile(
            icon: Icons.bookmark_border_rounded,
            label: 'My Favourites',
            onTap: () => _handleRestrictedTap(context, '/my_favorites'),
          ),
          const _MenuDivider(),

          // --- Section 2: General ---
          ProfileTile(
            icon: Icons.help_outline_rounded,
            label: 'Help & Support',
            onTap: () => Navigator.of(context).pushNamed('/help'),
          ),
          const _MenuDivider(),

          ProfileTile(
            icon: Icons.info_outline_rounded,
            label: 'About CooKit',
            onTap: () => Navigator.of(context).pushNamed('/about'),
          ),
        ],
      ),
    );
  }
}

// 3. Reusable Divider for cleaner code
class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
        height: 1,
        thickness: 1,
        indent: 56,
        endIndent: 16,
        color: AppColors.divider);
  }
}
