import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/chef_mato.png',
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 16),
        Text(
          'Sign Up or Log In',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181725),
          ),
        ),
      ],
    );
  }
}
