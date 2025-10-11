import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/onboarding_viewmodel.dart';
import '../onboarding/widgets/onboarding_backbutton.dart';
import 'widgets/login_header.dart';
import 'widgets/login_mainbutton.dart';
import 'widgets/login_socialbuttons.dart';
import 'widgets/login_footer.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button (top-left)
            OnboardingBackbutton(
              onPressed: () {
                ref
                    .read(onboardingProvider.notifier)
                    .setPage(2); // go to screen 3
                Navigator.pushReplacementNamed(context, '/onboarding');
              },
            ),

            //  Main login content (centered)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 32.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LoginHeader(),
                      const SizedBox(height: 24),
                      LoginMainButton(onPressed: () => _goHome(context)),
                      const SizedBox(height: 16),
                      Text(
                        'or',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF6B7280),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LoginSocialButtons(onPressed: () => _goHome(context)),
                      const SizedBox(height: 24),
                      const LoginFooterText(),
                    ],
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
