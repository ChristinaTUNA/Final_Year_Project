import 'package:cookit/core/theme/app_colors.dart';
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
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final canSend = _controller.text.trim().isNotEmpty;
    if (_canSend != canSend) {
      setState(() {
        _canSend = canSend;
      });
    }
  }

  void _handleSubmit() {
    if (_canSend) {
      widget.onSendPressed(_controller.text.trim());
      _controller.clear();
      // _canSend will update via listener
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Modern "Filled" style colors
    final inputFillColor =
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF2F4F5);
    final hintColor = isDark ? Colors.grey[500] : Colors.grey[500];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
          .copyWith(bottom: 24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 1. Text Field (Filled Pill Style)
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSubmit(),
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Ask Chef Mato...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: hintColor,
                ),
                filled: true,
                fillColor: inputFillColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1.5),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 2. Send Button (Animated Circle)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: _canSend ? AppColors.primary : inputFillColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_upward_rounded, // Modern "Send" arrow
                color: _canSend ? Colors.white : Colors.grey[400],
                size: 24,
              ),
              onPressed: _canSend ? _handleSubmit : null,
              tooltip: 'Send',
            ),
          ),
        ],
      ),
    );
  }
}
