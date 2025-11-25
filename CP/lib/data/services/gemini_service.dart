import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/scanned_ingredient.dart';

const String _openRouterApiKey =
    "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";

/// This service manages all interactions with the
/// Gemini (via OpenRouter) multimodal API.
class GeminiService {
  final http.Client _client = http.Client();

  final String _systemPrompt = """
Analyze this image of a kitchen counter, pantry, or fridge.
Identify ONLY the food ingredients.
Return your answer as a valid JSON array of objects, where each object has a "name" and "category".
Example: [{"name": "red onion", "quantity": "1", "category": "Vegetable"}, {"name": "chicken breast", quantity": "2", "category": "Poultry"}]
If you see no ingredients, return an empty array [].
""";

  /// Takes an image file, converts it to base64, and sends it to
  /// the OpenRouter Gemini API for analysis.
  Future<List<ScannedIngredient>> analyzeImage(XFile imageFile) async {
    // 1. Convert the image to a base64 string
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final mimeType = imageFile.mimeType ?? 'image/jpeg';
    final imageUrl = 'data:$mimeType;base64,$base64Image';

    // 2. Build the OpenRouter API request
    final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    final headers = {
      'Authorization': 'Bearer $_openRouterApiKey',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "model": "google/gemini-2.0-flash-exp:free",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": _systemPrompt,
            },
            {
              "type": "image_url",
              "image_url": {"url": imageUrl},
            }
          ]
        }
      ]
    });

    // 3. Send the request
    try {
      final response = await _client.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        // 4. Parse the *outer* JSON response
        final data = json.decode(response.body) as Map<String, dynamic>;
        final content = data['choices'][0]['message']['content'] as String;

        // 5. Parse the *inner* JSON (the actual ingredient list)
        final List<dynamic> ingredientListJson = json.decode(content);

        return ingredientListJson
            .map((json) =>
                ScannedIngredient.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        // Handle API errors (quota, etc.)
        throw Exception(
            'Failed to analyze image. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error sending request to OpenRouter: $e');
    }
  }
}

// --- PROVIDER ---
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});
