import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/scanned_ingredient.dart';

const String _openRouterApiKey =
    "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";

class ImageRecognitionService {
  final http.Client _client = http.Client();

  final String _systemPrompt = """
Analyze this image of a kitchen counter, pantry, or fridge.
Identify ONLY the food ingredients.
Return your answer as a valid JSON array of objects, where each object has a simplified format of "name" (single word/phrase) ,"quantity", and "category".
Example: [{"name": "red onion", "quantity": "1", "category": "Vegetable"}, {"name": "chicken breast", quantity": "2", "category": "Poultry"}]
If you see no ingredients, return an empty array [].
""";

  /// Takes an image file, converts it to base64, and sends it to
  /// the OpenRouter Gemini API for analysis.
  String _normalizeIngredient(String rawName) {
    return rawName.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '').trim();
  }

  Future<List<ScannedIngredient>> analyzeImage(XFile imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final mimeType = imageFile.mimeType ?? 'image/jpeg';
    final imageUrl = 'data:$mimeType;base64,$base64Image';

    final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    final headers = {
      'Authorization': 'Bearer $_openRouterApiKey',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "model": "x-ai/grok-4.1-fast:free",
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

    try {
      final response = await _client.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final content = data['choices'][0]['message']['content'] as String;

        // Clean up markdown code blocks if Gemini sends them
        final cleanContent =
            content.replaceAll('```json', '').replaceAll('```', '');

        final List<dynamic> ingredientListJson = json.decode(cleanContent);

        return ingredientListJson.map((json) {
          final rawName = json['name'] as String? ?? 'Unknown';
          final cleanName = _normalizeIngredient(rawName);

          return ScannedIngredient(
            name: cleanName,
            category: json['category'] as String? ?? 'Uncategorized',
            quantity: json['quantity'] as String? ?? '1',
          );
        }).toList();
      } else {
        throw Exception('Failed to analyze image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending request to OpenRouter: $e');
    }
  }
}

// --- PROVIDER ---
final imageRecognitionServiceProvider =
    Provider<ImageRecognitionService>((ref) {
  return ImageRecognitionService();
});
