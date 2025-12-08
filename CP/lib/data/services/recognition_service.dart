import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/scanned_ingredient.dart';

const String _googleApiKey = "AIzaSyA9hUQKuCNF7vuWo1hRZqc5F3gy3neWrqE";

class RecognitionService {
  final http.Client _client = http.Client();

  /// Analyzes image using Gemini 2.5 Flash (Direct Google API)
  Future<List<ScannedIngredient>> analyzeImage(XFile imageFile) async {
    // 1. Convert image to Base64
    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    // Ensure we have a valid mime type (fallback to jpeg if null)
    final mimeType = imageFile.mimeType ?? 'image/jpeg';

    // 2. The Smart Prompt
    const prompt = """
    Look at this image of food/pantry items. 
    Return a JSON list of ingredients found.
    Format: [{"name": "item name", "category": "category name", "quantity": "estimated quantity"}]
    
    Rules:
    - name: Singular, simple (e.g. "Apple", not "Red Apples").
    - category: General type (Produce, Dairy, Meat, Pantry, etc).
    - quantity: Estimate based on visual (e.g. "3", "1 bottle", "500g"). Default to "1".
    - Ignore non-food items.
    - Output ONLY raw JSON. No markdown.
    """;

    // 3. Prepare Request for Google AI API

    final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_googleApiKey');

    final body = json.encode({
      "contents": [
        {
          "parts": [
            {"text": prompt},
            {
              "inline_data": {"mime_type": mimeType, "data": base64Image}
            }
          ]
        }
      ],
      "generationConfig": {
        "response_mime_type": "application/json" // Enforce JSON mode
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

        // 4. Parse Gemini Response
        if (data['candidates'] != null &&
            (data['candidates'] as List).isNotEmpty) {
          final contentText =
              data['candidates'][0]['content']['parts'][0]['text'];

          // Clean up any potential markdown backticks (just in case)
          final cleanJson = contentText
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .trim();

          try {
            final List<dynamic> jsonList = json.decode(cleanJson);
            return jsonList.map((item) {
              return ScannedIngredient(
                name: item['name'] ?? 'Unknown',
                category: item['category'] ?? 'Pantry',
                quantity: item['quantity'] ?? '1',
              );
            }).toList();
          } catch (e) {
            // If JSON parsing fails (rare with 2.5 Flash + json mode), return empty
            throw Exception('JSON Parse Error: $e');
          }
        }
        return [];
      } else {
        // Log the full error body to help debugging

        throw Exception('Gemini API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('AI Analysis Failed: $e');
    }
  }
}

// --- PROVIDER ---
final imageRecognitionServiceProvider = Provider<RecognitionService>((ref) {
  return RecognitionService();
});
