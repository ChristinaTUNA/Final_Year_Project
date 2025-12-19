import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/data/models/chatbot_model.dart';
import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isBot = message.fromBot;

    // 1. Theme-aware Colors
    // Bot: Light Grey background, Dark text
    // User: Primary Red background, White text
    final bgColor = isBot ? const Color(0xFFF2F4F5) : AppColors.primary;
    final textColor = isBot ? AppColors.textDark : Colors.white;

    // 2. Custom "Speech Bubble" Shape
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isBot ? 0 : 20),
      bottomRight: Radius.circular(isBot ? 20 : 0),
    );

    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        // 3. Constrain width for better readability
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: textTheme.bodyLarge?.copyWith(
                color: textColor,
                height: 1.4,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 4),

            // 4. Timestamp
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatTime(message.timestamp),
                style: textTheme.labelSmall?.copyWith(
                  color: isBot
                      ? Colors.grey[500]
                      : Colors.white.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simple time formatter (e.g., 10:30 AM)
  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }
}
