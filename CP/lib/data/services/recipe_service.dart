// lib/data/services/recipe_service.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:cookit/data/models/filter_state.dart';
import 'package:cookit/data/models/recipe_model.dart';

const String _spoonacularApiKey = "35d09c6f61894bbfa03304a51c8b6269";

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final http.Client _client = http.Client();

// Fetches cached recipes from Firebase Firestore.
  Future<List<Recipe>> getCachedRecipes() async {
    try {
      final snapshot = await _firestore
          .collection('recipes')
          .limit(30) // Limit to 30 to be fast
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        // Convert Firestore JSON back to Recipe objects
        return Recipe.fromSpoonacularJson(doc.data());
      }).toList();
    } catch (e) {
      // If something goes wrong (e.g. permissions), return empty list
      throw Exception('Cache Fetch Error: $e');
    }
  }

  /// Searches recipes from Spoonacular API with given query and filters.
  Future<List<Recipe>> searchRecipes(String query, FilterState filters) async {
    // Base parameters
    final queryParams = {
      'apiKey': _spoonacularApiKey,
      'query': query,
      'number': '20',
      'instructionsRequired': 'true',
      'addRecipeInformation': 'true', // Needed for time/rating
    };

    // 1. Handle Sort
    if (filters.sortBy.isNotEmpty) {
      switch (filters.sortBy) {
        case 'Prep Time':
          queryParams['sort'] = 'time';
          queryParams['sortDirection'] = 'asc';
          break;
        case 'Ratings':
          queryParams['sort'] =
              'popularity'; // Spoonacular uses popularity/healthiness
          break;
        case 'Popularity':
          queryParams['sort'] = 'popularity';
          break;
        // Add more cases as needed
      }
    }

    // 2. Handle Cuisines
    if (filters.cuisines.isNotEmpty) {
      queryParams['cuisine'] = filters.cuisines.join(',');
    }

    // 3. Handle Tags (Diet/Type)
    if (filters.tags.isNotEmpty) {
      queryParams['diet'] = filters.tags.join(',');
    }

    final uri = Uri.https(
      'api.spoonacular.com',
      '/recipes/complexSearch',
      queryParams,
    );

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
final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService();
});
