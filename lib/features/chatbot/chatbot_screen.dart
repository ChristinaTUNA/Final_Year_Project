import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/features/chatbot/chatbot_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _showChatMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Clear Conversation',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context); // Close sheet
                _confirmClearChat();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClearChat() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Chat?'),
        content: const Text('This will remove all messages from this session.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              ref.read(chatbotViewModelProvider.notifier).clearChat();
              Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatbotViewModelProvider);
    final viewModel = ref.read(chatbotViewModelProvider.notifier);
    final messages = chatState.messages;

    ref.listen(chatbotViewModelProvider, (previous, next) {
      final prevLen = previous?.messages.length ?? 0;
      final nextLen = next.messages.length;
      final startedLoading = next.isLoading && !(previous?.isLoading ?? false);

      if (nextLen > prevLen || startedLoading) {
        _scrollToBottom();
      }
    });

    final bool hasUserTyped = messages.any((msg) => !msg.fromBot);
    final bool showSuggestions = !hasUserTyped && !chatState.isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ChatbotAppBar(
        onBackPressed: () => Navigator.of(context).pop(),
        onMenuPressed: _showChatMenu,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: AppSpacing.pHorizontalLg.copyWith(
                top: AppSpacing.lg,
                bottom: AppSpacing.lg,
              ),
              itemCount: 1 + messages.length + (chatState.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                // 1. Avatar
                if (index == 0) {
                  return ChatbotAvatar(pulseAnimation: _pulseAnimation);
                }

                final msgIndex = index - 1;

                // 2. Loading Indicator
                if (chatState.isLoading && msgIndex == messages.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.primary),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Chef Mato is typing...",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 3. Message Bubble
                if (msgIndex < messages.length) {
                  final msg = messages[msgIndex];
                  return ChatMessageBubble(message: msg);
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // SUGGESTIONS STRIP
          if (showSuggestions)
            Container(
              height: 110,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final suggestion = _suggestions[i];
                  return Center(
                    // Center vertically
                    child: ChatbotSuggestionChip(
                      title: suggestion['title']!,
                      subtitle: suggestion['subtitle']!,
                      onTap: () => viewModel.sendMessage(
                          "${suggestion['title']} ${suggestion['subtitle']}"),
                    ),
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
