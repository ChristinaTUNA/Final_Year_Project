import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/placeholder_page.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_logout.dart';
import 'widgets/profile_menu_list.dart';
import 'profile_viewmodel.dart';

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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: AppSpacing.pHorizontalLg.copyWith(top: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: textTheme.displayLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    userAsync.when(
                      data: (user) => ProfileHeader(
                        user: user,
                        onEdit: () => _onPushEditProfile(context),
                      ),
                      loading: () => const SizedBox(
                        height: 80,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      // Error state handling
                      error: (err, stack) =>
                          const Text('Error loading profile'),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    ProfileMenuList(
                      onPushPlaceholder: (title) =>
                          _onPushPlaceholder(context, title),
                    ),

                    const Spacer(),

                    LogoutButton(
                      onLogout: () => _onLogout(context, ref),
                    ),
                    const SizedBox(height: AppSpacing.xl), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
