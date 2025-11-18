import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ChatbotAvatar extends StatelessWidget {
  final Animation<double> pulseAnimation;

  const ChatbotAvatar({super.key, required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: ScaleTransition(
          scale: pulseAnimation,
          child: CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary,
            child: ClipOval(
              child: Image.asset(
                'assets/images/chef_mato.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
