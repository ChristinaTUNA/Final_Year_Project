import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileTile(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final iconTheme = Theme.of(context).iconTheme;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.backgroundNeutral,
          borderRadius: AppBorders.allMd,
        ),
        child: Icon(icon, color: iconTheme.color),
      ),
      title: Text(
        label,
        style: textTheme.titleMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
