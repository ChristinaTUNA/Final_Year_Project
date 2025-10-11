import 'package:flutter/material.dart';

class LoginSocialButtons extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginSocialButtons({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SocialButton(
          iconPath: 'assets/images/Google.png',
          onTap: onPressed,
        ),
        const SizedBox(width: 16),
        _SocialButton(
          iconPath: 'assets/images/Facebook.png',
          onTap: onPressed,
        ),
        const SizedBox(width: 16),
        _SocialButton(
          iconPath: 'assets/images/Email.png',
          onTap: onPressed,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const _SocialButton({required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 252, 233, 229),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
