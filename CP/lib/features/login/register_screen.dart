import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:cookit/features/login/widgets/login_socialbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/features/login/login_viewmodel.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    // Controllers (Ideally manage these in a StatefulWidget or separate Logic)
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                size: 18, color: Colors.black),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/auth_landing'),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.pAllXl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Hello! Register to get\nstarted',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Username
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Username',
                  fillColor: Color(0xFFF7F8F9),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  fillColor: Color(0xFFF7F8F9),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Password
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  fillColor: Color(0xFFF7F8F9),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Confirm Password
              TextFormField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirm password',
                  fillColor: Color(0xFFF7F8F9),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (passwordController.text ==
                              confirmController.text) {
                            viewModel.signInWithEmail(
                              emailController.text,
                              passwordController.text,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Passwords do not match')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Register'),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Or Register with',
                        style: AppTextStyles.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Social Row (Google Only)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialLoginButton(
                    iconPath: 'assets/icons/google_logo.svg',
                    onTap: () => viewModel.signInWithGoogle(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text(
                      'Login Now',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
