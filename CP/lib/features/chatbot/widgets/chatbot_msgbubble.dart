import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/chatbot_model.dart';
import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // ⬇️ Use theme-aware colors
    final bgColor =
        message.fromBot ? AppColors.backgroundNeutral : AppColors.primary;
    final textColor =
        message.fromBot ? textTheme.bodyLarge?.color : AppColors.white;

    return Align(
      alignment: message.fromBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        padding: AppSpacing.pAllMd, // 16px
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppBorders.allMd,
        ),
        child: Text(
          message.text,
          style: textTheme.bodyLarge?.copyWith(color: textColor),
        ),
      ),
    );
  }
}
