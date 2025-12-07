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

  // Smart Name Extraction Logic
  String get _displayName {
    // 1. Handle Guest/Null
    if (user == null) return 'Guest';

    // 2. Handle Display Name (if set)
    if (user!.displayName != null && user!.displayName!.isNotEmpty) {
      return user!.displayName!;
    }

    // 3. Handle Email Fallback
    if (user!.email != null && user!.email!.isNotEmpty) {
      // Split by @ to get username
      final parts = user!.email!.split('@');
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        final name = parts[0];
        // Safety check: Ensure name has at least 1 char before accessing [0]
        if (name.length > 1) {
          return "${name[0].toUpperCase()}${name.substring(1)}";
        }
        return name.toUpperCase();
      }
    }

    return 'Chef';
  }

  String get _email => user?.email ?? 'No email';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.primary.withValues(alpha: .1),
          backgroundImage:
              user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
          child: user?.photoURL == null
              ? const Icon(Icons.person, size: 32, color: AppColors.primary)
              : null,
        ),
        const SizedBox(width: 16),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _displayName,
                style: textTheme.headlineMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _email,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Edit Icon
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit, color: AppColors.primary),
        ),
      ],
    );
  }
}
