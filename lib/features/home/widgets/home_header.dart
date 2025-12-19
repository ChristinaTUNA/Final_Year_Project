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

    // 1. Try Display Name
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.split(' ').first;
    }

    // 2. Try Email Username
    if (user.email != null && user.email!.isNotEmpty) {
      final parts = user.email!.split('@');
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        final name = parts[0];
        // Capitalize first letter
        if (name.length > 1) {
          return "${name[0].toUpperCase()}${name.substring(1)}";
        }
        return name.toUpperCase();
      }
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
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Side: Welcome Text
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, $displayName!',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.white,
                        height: 1.1,
                        fontSize: 28,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ready to cook something delicious?',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Right Side: Profile Avatar with Action
              GestureDetector(
                onTap: () => ref.read(rootShellProvider.notifier).setIndex(3),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    border: Border.all(color: AppColors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    image: photoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(photoUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: photoUrl == null
                      ? const Icon(Icons.person_rounded,
                          color: AppColors.primary)
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
