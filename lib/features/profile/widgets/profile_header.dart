import 'package:cookit/core/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final User? user;
  final VoidCallback onEdit;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.onEdit,
  });

  String get _displayName {
    if (user == null) return 'Guest';
    if (user!.displayName != null && user!.displayName!.isNotEmpty) {
      return user!.displayName!;
    }
    if (user!.email != null && user!.email!.isNotEmpty) {
      final parts = user!.email!.split('@');
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        final name = parts[0];
        if (name.length > 1) {
          return "${name[0].toUpperCase()}${name.substring(1)}";
        }
        return name.toUpperCase();
      }
    }
    return 'Chef';
  }

  String get _email => user?.email ?? 'Sign in to sync your data';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        // 1. Avatar with Border
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2), width: 1),
          ),
          child: CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null
                ? const Icon(Icons.person_rounded,
                    size: 36, color: AppColors.primary)
                : null,
          ),
        ),
        const SizedBox(width: 16),

        // 2. Info Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _displayName,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _email,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // 3. Edit Action

        IconButton(
          onPressed: onEdit,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            foregroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.edit_rounded, size: 20),
          tooltip: 'Edit Profile',
        ),
      ],
    );
  }
}
