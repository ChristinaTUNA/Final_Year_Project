import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/features/chatbot/chatbot_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/chatbot_appbar.dart';
import 'widgets/chatbot_avatar.dart';
import 'widgets/chatbot_inputbar.dart';
import 'widgets/chatbot_msgbubble.dart';
import 'widgets/chatbot_suggestionchip.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _suggestions = [
    {'title': 'Recommend a breakfast', 'subtitle': 'high-protein'},
    {'title': 'Quick lunch ideas', 'subtitle': 'under 15 mins'},
    {'title': 'Low-carb dinner', 'subtitle': 'healthy weeknight'},
    {'title': 'Vegetarian protein', 'subtitle': 'chicken swaps'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    _pulseAnimation = Tween(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60, // Add padding
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⬇️ Watch the ViewModel
    final chatState = ref.watch(chatbotViewModelProvider);
    final viewModel = ref.read(chatbotViewModelProvider.notifier);
    final messages = chatState.messages;

    // Scroll to bottom when new message arrives
    ref.listen(chatbotViewModelProvider, (previous, next) {
      if (next.messages.length > (previous?.messages.length ?? 0)) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ChatbotAppBar(
        onBackPressed: () => Navigator.of(context).pop(),
        onMenuPressed: () {},
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: AppSpacing.pHorizontalLg
                  .copyWith(top: AppSpacing.lg, bottom: AppSpacing.lg),
              // Count = messages + avatar + loading indicator
              itemCount: messages.length + 1 + (chatState.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                // 1. Avatar at the top
                if (index == 0) {
                  return ChatbotAvatar(pulseAnimation: _pulseAnimation);
                }

                // 2. Loading Indicator (at the bottom if loading)
                if (index == messages.length + 1) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Chef Mato is thinking...",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  );
                }

                // 3. Messages
                final msg = messages[index - 1];
                return ChatMessageBubble(message: msg);
              },
            ),
          ),

          // Suggestions strip (Hide if we have messages)
          if (messages.isEmpty)
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
                    onTap: () => viewModel.sendMessage(
                        "${suggestion['title']} ${suggestion['subtitle']}"),
                  );
                },
              ),
            ),

          ChatbotInputBar(
            onSendPressed: (text) => viewModel.sendMessage(text),
          ),
        ],
      ),
    );
  }
}
