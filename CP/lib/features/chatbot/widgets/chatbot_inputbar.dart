import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/core/theme/app_borders.dart';
import 'package:flutter/material.dart';

class ChatbotInputBar extends StatefulWidget {
  final Function(String) onSendPressed;

  const ChatbotInputBar({super.key, required this.onSendPressed});

  @override
  State<ChatbotInputBar> createState() => _ChatbotInputBarState();
}

class _ChatbotInputBarState extends State<ChatbotInputBar> {
  final _controller = TextEditingController();
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _canSend = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_canSend) {
      widget.onSendPressed(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _canSend ? AppColors.primary : AppColors.textLightGray;

    return Container(
      padding: AppSpacing.pHorizontalMd.copyWith(
        top: AppSpacing.sm,
        bottom: AppSpacing.lg, // More padding at the bottom
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            // ⬇️ This TextField will automatically use the
            // 'inputDecorationTheme' from your app_theme.dart
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _handleSubmit(),
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                // ⬇️ Use a simpler border for a chat bar
                border: OutlineInputBorder(
                  borderRadius: AppBorders.allXxl, // Pill shape
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppBorders.allXxl,
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppBorders.allXxl,
                  borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                ),
              ),
              maxLines: 5,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: Icon(Icons.send, color: iconColor),
            onPressed: _canSend ? _handleSubmit : null,
          ),
        ],
      ),
    );
  }
}
