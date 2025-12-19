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

  ChatbotViewModel(this._service) : super(const ChatState());

  void clearChat() {
    state = const ChatState(messages: [], isLoading: false);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. Add User Message
    final userMsg = ChatMessage(text: text, fromBot: false);
    final currentHistory = List<ChatMessage>.from(state.messages);

    state = state.copyWith(
      messages: [...currentHistory, userMsg],
      isLoading: true,
    );

    try {
      // 2. Call API
      final responseText = await _service.sendMessage(text, currentHistory);

      // 3. Add Bot Response
      final botMsg = ChatMessage(text: responseText, fromBot: true);

      state = state.copyWith(
        messages: [...state.messages, botMsg],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
              text: "Sorry, I'm having trouble thinking right now.",
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
