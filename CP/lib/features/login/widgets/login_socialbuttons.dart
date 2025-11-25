import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSvg = iconPath.endsWith('.svg');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Fixed width
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Center(
          child: isSvg
              ? SvgPicture.asset(
                  iconPath,
                  height: 24,
                  width: 24,
                )
              : Image.asset(
                  iconPath,
                  height: 24,
                  width: 24,
                ),
        ),
      ),
    );
  }
}
