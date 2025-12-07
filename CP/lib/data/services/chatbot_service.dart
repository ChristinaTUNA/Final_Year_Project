import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chatbot_model.dart';

const String _openRouterApiKey =
    "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";

class ChatbotService {
  final http.Client _client = http.Client();

  final String _systemInstruction = """
You are Chef Mato, a friendly and enthusiastic cooking assistant.
You help users find recipes, suggest ingredient swaps, and give cooking tips.
Keep your answers concise, helpful, and encouraging.
If asked about non-food topics, politely steer the conversation back to cooking.
""";

  Future<String> sendMessage(String message, List<ChatMessage> history) async {
    final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    // 1. Build Conversation History for Context
    // We convert your app's message list into the API's format
    final messages = [
      {"role": "system", "content": _systemInstruction},
      ...history.map((msg) => {
            "role": msg.fromBot ? "assistant" : "user",
            "content": msg.text,
          }),
      {"role": "user", "content": message}
    ];

    final body = json.encode({
      "model": "openai/gpt-oss-20b:free", // Fast & Good for chat
      "messages": messages,
    });

    try {
      final response = await _client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $_openRouterApiKey',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'] ??
            "I'm not sure what to say.";
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  return ChatbotService();
});
