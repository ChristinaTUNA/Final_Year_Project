import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'profile_tile.dart';

class ProfileMenuList extends StatelessWidget {
  final void Function(String) onPushPlaceholder;

  const ProfileMenuList({super.key, required this.onPushPlaceholder});

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
      ),
      child: Column(
        children: [
          ProfileTile(
            icon: Icons.calendar_today_outlined,
            label: 'My Preferences',
            onTap: () => Navigator.of(context).pushNamed('/edit_preferences'),
          ),
          const Divider(height: 10, color: AppColors.divider),
          ProfileTile(
            icon: Icons.bookmark_outline,
            label: 'My Favourites',
            onTap: () => Navigator.of(context).pushNamed('/my_favorites'),
          ),
          const Divider(height: 10, color: AppColors.divider),
          ProfileTile(
            icon: Icons.help_outline,
            label: 'Help',
            onTap: () => Navigator.of(context).pushNamed('/help'),
          ),
          const Divider(height: 10, color: AppColors.divider),
          ProfileTile(
            icon: Icons.info_outline,
            label: 'About',
            onTap: () => Navigator.of(context).pushNamed('/about'),
          ),
        ],
      ),
    );
  }
}
