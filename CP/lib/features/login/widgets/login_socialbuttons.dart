import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class LoginSocialButtons extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginSocialButtons({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SocialButton(
          iconPath: 'assets/icons/Google.png',
          onTap: onPressed,
        ),
        const SizedBox(width: AppSpacing.md),
        _SocialButton(
          iconPath: 'assets/icons/Facebook.png',
          onTap: onPressed,
        ),
        const SizedBox(width: AppSpacing.md),
        _SocialButton(
          iconPath: 'assets/icons/Email.png',
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
        borderRadius: AppBorders.allMd,
        child: Container(
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: AppBorders.allMd,
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
