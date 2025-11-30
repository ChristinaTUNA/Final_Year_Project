import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/chatbot_model.dart';
import 'package:flutter/material.dart';
import 'widgets/chatbot_appbar.dart';
import 'widgets/chatbot_avatar.dart';
import 'widgets/chatbot_inputbar.dart';
import 'widgets/chatbot_msgbubble.dart';
import 'widgets/chatbot_suggestionchip.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with SingleTickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  final List<Map<String, String>> _suggestions = [
    {
      'title': 'Recommend a breakfast recipe',
      'subtitle': 'for a high-protein start to the day'
    },
    {
      'title': 'Suggest a quick lunch',
      'subtitle': 'that takes under 15 minutes'
    },
    {'title': 'Low-carb dinner ideas', 'subtitle': 'for a healthy weeknight'},
    {'title': 'Vegetarian protein swaps', 'subtitle': 'to replace chicken'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    _pulseAnimation = Tween(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  } //TODO: make it work

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, fromBot: false));
    });

    // Simulate bot response
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add(ChatMessage(
            text: 'Got it — here are a few ideas for: "$text"', fromBot: true));
      });
    });
  }

  void _openMenu() {
    // Placeholder for menu action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu button pressed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ChatbotAppBar(
        onBackPressed: () => Navigator.of(context).pop(),
        onMenuPressed: _openMenu,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: AppSpacing.pHorizontalLg
                  .copyWith(top: AppSpacing.lg, bottom: AppSpacing.lg),
              itemCount: _messages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ChatbotAvatar(pulseAnimation: _pulseAnimation);
                }
                final msg = _messages[index - 1];
                return ChatMessageBubble(message: msg);
              },
            ),
          ),

          // Suggestions strip
          if (_messages.isEmpty)
            Container(
              height: 96,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final suggestion = _suggestions[i];
                  return ChatbotSuggestionChip(
                    title: suggestion['title']!,
                    subtitle: suggestion['subtitle']!,
                    onTap: () => _sendMessage(suggestion['title']!),
                  );
                },
              ),
            ),

          ChatbotInputBar(
            onSendPressed: (text) => _sendMessage(text),
          ),
        ],
      ),
    );
  }
}
