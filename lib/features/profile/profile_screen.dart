import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/features/profile/profile_viewmodel.dart';
import 'package:cookit/features/profile/widgets/profile_header.dart';
import 'package:cookit/features/profile/widgets/profile_logout.dart';
import 'package:cookit/features/profile/widgets/profile_menu_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/placeholder_page.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _onPushEditProfile(BuildContext context) {
    Navigator.of(context).pushNamed('/edit_profile');
  }

  void _onPushPlaceholder(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaceholderPage(title: title),
      ),
    );
  }

  void _onLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(profileViewModelProvider.notifier).signOut();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final userAsync = ref.watch(userProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: userAsync.when(
        data: (user) {
          final isAnon = user?.isAnonymous ?? false;

          return CustomScrollView(
            slivers: [
              // 1. Sliver App Bar with Large Title
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                  title: Text(
                    'Profile',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 2. Profile Header (Avatar & Email)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: ProfileHeader(
                      user: user,
                      onEdit: () => _onPushEditProfile(context),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

              // 3. Menu List
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 12),
                        child: Text(
                          "Settings",
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.textGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ProfileMenuList(
                        isAnonymous: isAnon,
                        onPushPlaceholder: (title) =>
                            _onPushPlaceholder(context, title),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

              // 4. Logout Button
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LogoutButton(
                        onLogout: () => _onLogout(context, ref),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Version 1.0.0",
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textLightGray,
                        ),
                      ),
                      const SizedBox(height: 80)
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
