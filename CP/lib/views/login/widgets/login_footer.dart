import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginFooterText extends StatelessWidget {
  const LoginFooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'By logging in or registering, you agree to our ',
        style: GoogleFonts.poppins(color: const Color(0xFF9CA3AF)),
        children: [
          TextSpan(
            text: 'Terms of Service.',
            style: GoogleFonts.poppins(color: const Color(0xFF2563EB)),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
