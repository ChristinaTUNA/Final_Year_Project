import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ChatbotAvatar extends StatelessWidget {
  final Animation<double> pulseAnimation;

  const ChatbotAvatar({super.key, required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Animated Avatar with Glow
          ScaleTransition(
            scale: pulseAnimation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
                // Subtle border
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.1), width: 3),
                // Soft shadow for depth
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/images/chef_mato_f.png',
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, st) => const Icon(
                      Icons.smart_toy_rounded,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // 2. Persona Introduction
          Text(
            "I'm Chef Mato!",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Ask me for recipes, tips, or ideas.",
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
