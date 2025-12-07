import 'package:cookit/data/models/chatbot_model.dart';
import 'package:cookit/data/services/chatbot_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State to hold messages + loading status
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatbotViewModel extends StateNotifier<ChatState> {
  final ChatbotService _service;

  ChatbotViewModel(this._service) : super(const ChatState()) {
    // Add a welcome message
    state = ChatState(messages: [
      ChatMessage(
          text: "Hi! I'm Chef Mato. What are we cooking today?", fromBot: true)
    ]);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. Add User Message immediately
    final userMsg = ChatMessage(text: text, fromBot: false);
    final currentHistory = List<ChatMessage>.from(state.messages);

    state = state.copyWith(
      messages: [...currentHistory, userMsg],
      isLoading: true, // Show loading indicator
    );

    try {
      // 2. Call API (Pass history for context)
      final responseText = await _service.sendMessage(text, currentHistory);

      // 3. Add Bot Response
      final botMsg = ChatMessage(text: responseText, fromBot: true);

      state = state.copyWith(
        messages: [...state.messages, botMsg],
        isLoading: false,
      );
    } catch (e) {
      // Handle Error
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
              text: "Sorry, I'm having trouble thinking right now. ($e)",
              fromBot: true)
        ],
        isLoading: false,
      );
    }
  }
}

final chatbotViewModelProvider =
    StateNotifierProvider<ChatbotViewModel, ChatState>((ref) {
  final service = ref.watch(chatbotServiceProvider);
  return ChatbotViewModel(service);
});
