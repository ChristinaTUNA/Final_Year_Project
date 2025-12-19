import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/features/login/login_viewmodel.dart';
import 'package:cookit/features/login/widgets/login_socialbuttons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    ref.listen(loginViewModelProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!), backgroundColor: Colors.red));
      }
      if (next.navigationRoute != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, next.navigationRoute!, (route) => false);
      }
    });

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
                'Welcome back! Glad\nto see you, Again!',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  fillColor: Color(0xFFF7F8F9),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  fillColor: const Color(0xFFF7F8F9),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
              ),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {}, // TODO: Implement Forgot Password
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () => viewModel.signInWithEmail(
                            _emailController.text,
                            _passwordController.text,
                          ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login'),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Or Login with
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child:
                        Text('Or Login with', style: AppTextStyles.bodySmall),
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

              // Register Now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/register'),
                    child: const Text(
                      'Register Now',
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
