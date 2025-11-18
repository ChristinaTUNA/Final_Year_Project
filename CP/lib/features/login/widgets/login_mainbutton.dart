import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginMainButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final String? iconPath;

  const LoginMainButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.iconPath,
    this.isLoading = false,
  });

  Widget _buildIcon(String path) {
    if (path.endsWith('.svg')) {
      // SVGs need a color filter to match the white button text
      return SvgPicture.asset(
        path,
        height: 24,
        width: 24,
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
      );
    } else if (path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.webp')) {
      return Image.asset(
        path,
        height: 24,
        width: 24,
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final defaultButtonStyle = Theme.of(context).elevatedButtonTheme.style;

    final buttonStyle = defaultButtonStyle;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        icon:
            iconPath != null ? _buildIcon(iconPath!) : const SizedBox.shrink(),
        label: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text),
      ),
    );
  }
}
