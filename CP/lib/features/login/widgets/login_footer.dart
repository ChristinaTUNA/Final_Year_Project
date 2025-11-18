// lib/features/login/widgets/login_footer.dart
import 'package:flutter/material.dart';

class LoginFooterText extends StatelessWidget {
  const LoginFooterText({super.key});

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodySmall;
    final linkStyle = baseStyle?.copyWith(color: const Color(0xFF2563EB));

    return Text.rich(
      TextSpan(
        text: 'By logging in or registering, you agree to our ',
        style: baseStyle,
        children: [
          TextSpan(
            text: 'Terms of Service.',
            style: linkStyle,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
