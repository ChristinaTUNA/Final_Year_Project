import 'dart:convert';
import 'package:cookit/data/models/chatbot_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotService {
  final http.Client _client = http.Client();

  final String _apiKey = dotenv.env['GOOGLE_AI_KEY'] ?? '';

  final String _systemInstruction = """
You are Chef Mato, a friendly and simple cooking assistant. 
Your goal is to help users find quick and easy recipes.

Guidelines:
1. **Persona:** Friendly, encouraging, and concise.
2. **Recipe Format:** When asked for a recipe, always use this simple structure:
   - 🍳 **Title**
   - 🛒 **Ingredients** (Bullet points)
   - 👩‍🍳 **Instructions** (Numbered list)
   - 💡 **Chef's Tip** (One quick tip)
3. **Scope:** Only answer questions about food, cooking, and ingredients. If asked about other topics, politely decline and offer a recipe instead.
4. **Brevity:** Keep instructions short and easy to read on a mobile screen.
""";

  Future<String> sendMessage(String message, List<ChatMessage> history) async {
    if (_apiKey.isEmpty) {
      return "Configuration Error: API Key not found. Please check your .env file.";
    }

    final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey');

    // 1. Format History for Gemini API
    final contents = history.map((msg) {
      return {
        "role": msg.fromBot ? "model" : "user",
        "parts": [
          {"text": msg.text}
        ]
      };
    }).toList();

    // 2. Add the current new message
    contents.add({
      "role": "user",
      "parts": [
        {"text": message}
      ]
    });

    // 3. Build Request Body with System Instruction
    final body = json.encode({
      "contents": contents,
      "systemInstruction": {
        "parts": [
          {"text": _systemInstruction}
        ]
      },
      "generationConfig": {
        "temperature": 0.7, // Slightly creative for recipes
        "maxOutputTokens": 800, // Limit length for mobile readability
      }
    });

    try {
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 4. Parse Google Response
        if (data['candidates'] != null &&
            (data['candidates'] as List).isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null) {
            return candidate['content']['parts'][0]['text'];
          }
        }
        return "I'm having a little trouble finding that recipe right now. Could you try asking again?";
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Return a friendly error message to the chat instead of crashing
      return "I'm having trouble connecting to the kitchen server. Please check your internet connection.";
    }
  }
}

final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  return ChatbotService();
});
