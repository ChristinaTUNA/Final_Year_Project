import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:cookit/features/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthLandingScreen extends ConsumerWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final state = ref.watch(loginViewModelProvider);

    // Make status bar transparent
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image (Top 60%)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Image.asset(
              'assets/images/onboarding_1.webp', // Use your plant/food image here
              fit: BoxFit.cover,
            ),
          ),

          // 2. White Content Area (Bottom 40%)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: AppSpacing.pAllXl,
              decoration: const BoxDecoration(
                color: Colors.white,
                // No rounded corners in your reference image, flat top
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  // Login Button (Solid Primary)
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // Your Theme Red
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppBorders.allMd,
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: AppTextStyles.labelLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Register Button (Outlined)
                  SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.textDark),
                        foregroundColor: AppColors.textDark,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppBorders.allMd,
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Guest Link
                  Center(
                    child: TextButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              viewModel.signInAnonymously();
                              // Navigation is handled by the listener in the parent widget
                              // or we can do it here if we pass context
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/home', (route) => false);
                            },
                      child: Text(
                        'Continue as a guest',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary, // Your Theme Red
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
