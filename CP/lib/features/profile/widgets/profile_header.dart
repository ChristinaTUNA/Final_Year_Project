import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onEdit;
  final User? user;

  const ProfileHeader({
    super.key,
    required this.onEdit,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final String displayName = user?.displayName ?? 'Guest';
    final String email = user?.email ?? 'Anonymous';
    final String? photoUrl = user?.photoURL;

    final ImageProvider avatarImage;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      avatarImage = NetworkImage(photoUrl);
    } else {
      avatarImage = const AssetImage('assets/images/chef_mato.png');
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: avatarImage,
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: textTheme.displaySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                email,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit, color: AppColors.primary),
        ),
      ],
    );
  }
}
