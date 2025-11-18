// lib/features/chatbot/widgets/chatbot_appbar.dart
import 'package:flutter/material.dart';

class ChatbotAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onMenuPressed;

  const ChatbotAppBar({
    super.key,
    required this.onBackPressed,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final iconColor = Theme.of(context).iconTheme.color;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor),
        onPressed: onBackPressed,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ChatBOT',
            style: textTheme.displayMedium,
          ),
          const SizedBox(width: 6),
          Text(
            '1.0',
            style: textTheme.bodySmall?.copyWith(fontSize: 15),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: iconColor),
          onPressed: onMenuPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
