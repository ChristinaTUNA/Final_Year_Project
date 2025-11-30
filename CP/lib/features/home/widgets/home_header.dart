// lib/features/home/widgets/home_header.dart
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:cookit/features/shared/root_shell_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  String _getDisplayName(User? user) {
    if (user == null) return 'Chef';
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!.split(' ').first;
    }
    if (user.email != null && user.email!.isNotEmpty) {
      final emailName = user.email!.split('@').first;
      return "${emailName[0].toUpperCase()}${emailName.substring(1)}";
    }
    return 'Chef';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final displayName = _getDisplayName(user);
        final photoUrl = user?.photoURL;

        return SizedBox(
          height: 120,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side Text
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hi, $displayName!',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ready to cook something delicious?',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile Picture
                GestureDetector(
                  onTap: () => ref.read(rootShellProvider.notifier).setIndex(3),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      border: Border.all(color: AppColors.white, width: 2),
                      image: photoUrl != null
                          ? DecorationImage(
                              image: NetworkImage(photoUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: photoUrl == null
                        ? const Icon(Icons.person, color: AppColors.primary)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
