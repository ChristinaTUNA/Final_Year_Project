import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../intro/intro_viewmodel.dart';
import '../intro/widgets/intro_backbutton.dart';
import 'widgets/login_header.dart';
import 'widgets/login_mainbutton.dart';
import 'widgets/login_footer.dart';
import 'login_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    ref.listen(loginViewModelProvider, (previous, next) {
      // 1. Check for errors
      if (next.error != null && (previous?.error != next.error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }

      // 2. Check for success
      if (next.loginSuccess) {
        Navigator.pushReplacementNamed(context, '/preference');
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            IntroBackButton(
              onPressed: () {
                ref.read(introViewModelProvider.notifier).setPage(2);
                Navigator.pushReplacementNamed(context, '/intro');
              },
            ),
            Center(
              child: Padding(
                padding: AppSpacing.pAllXl,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LoginHeader(),
                        const SizedBox(height: AppSpacing.lg),
                        LoginMainButton(
                          text: 'Continue with Google',
                          iconPath: 'assets/icons/Google.svg',
                          isLoading: state.isLoading,
                          onPressed: () => viewModel.signInWithGoogle(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'or',
                          style: textTheme.bodyMedium?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        //  --- NEW: Email/Password Fields ---
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          // ⬇️ This is a secondary-style button
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryLight,
                              foregroundColor: AppColors.primary,
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppBorders.allMd,
                              ),
                              elevation: 0,
                            ),
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    // ⬇️ REMOVED context
                                    viewModel.signInWithEmail(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  },
                            child: state.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Continue with Email'),
                          ),
                        ),
                        //  --- END: Email/Password Fields ---

                        const SizedBox(height: AppSpacing.lg),
                        const LoginFooterText(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
