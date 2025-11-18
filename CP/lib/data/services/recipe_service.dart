// lib/data/services/recipe_service.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

const String _spoonacularApiKey = "35d09c6f61894bbfa03304a51c8b6269";

/// This service manages fetching recipe details, implementing the
/// Firebase caching strategy to save Spoonacular API points.
class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final http.Client _client = http.Client();

  Future<List<Recipe>> searchRecipes(String query, String filter) async {
    // Start building the query
    var queryString = 'apiKey=$_spoonacularApiKey&query=$query&number=35';

    // Add the filter if it's not "All"
    if (filter != 'All') {
      if (filter.contains('mins')) {
        // Handle a time filter
        final time = filter.split(' ').first;
        queryString += '&maxReadyTime=$time';
      } else {
        // Handle a diet/cuisine filter
        queryString += '&diet=$filter'; // or &cuisine=$filter
      }
    }
    final uri = Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?$queryString');

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      // Use the 'fromSpoonacularSearchJson' factory
      return results
          .map((json) =>
              Recipe.fromSpoonacularSearchJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to search recipes: ${response.statusCode}');
    }
  }

  /// Fetches full recipe details, following the capstone caching logic.
  Future<Recipe> getRecipeDetails(int recipeId) async {
    final cacheDoc = _firestore.collection('recipes').doc(recipeId.toString());

    // 1. Check Firebase Cache
    final snapshot = await cacheDoc.get();
    if (snapshot.exists && snapshot.data() != null) {
      // Recipe is in cache! Cost: 0 points.
      return Recipe.fromSpoonacularJson(snapshot.data()!);
    }

    // 2. Not in cache. Fetch from Spoonacular. Cost: 1 point.
    final recipe = await _fetchFromSpoonacular(recipeId);

    // 3. Save to Firebase Cache for next time
    await cacheDoc.set(recipe);

    return Recipe.fromSpoonacularJson(recipe);
  }

  /// Private helper to call the Spoonacular API.
  Future<Map<String, dynamic>> _fetchFromSpoonacular(int recipeId) async {
    final uri = Uri.parse(
        'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$_spoonacularApiKey&includeNutrition=false');

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 402) {
      // 402 = Quota reached
      throw Exception('API Quota Reached. Please try again tomorrow.');
    } else {
      throw Exception('Failed to load recipe: ${response.statusCode}');
    }
  }
}

// --- PROVIDERS ---

/// Simple provider for the service itself.
final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService();
});
