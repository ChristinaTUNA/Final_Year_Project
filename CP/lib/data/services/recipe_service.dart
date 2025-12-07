import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';
import 'package:cookit/data/models/filter_state.dart';

const String _spoonacularApiKey = "35d09c6f61894bbfa03304a51c8b6269";

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final http.Client _client = http.Client();

  // ===========================================================================
  // PUBLIC METHODS (Called by ViewModels)
  // ===========================================================================

  /// Fetches recently cached recipes from Firestore (Fast & Free).
  Future<List<Recipe>> getCachedRecipes() async {
    try {
      final snapshot = await _firestore.collection('recipes').limit(30).get();

      if (snapshot.docs.isEmpty) return [];

      return snapshot.docs.map((doc) {
        return Recipe.fromSpoonacularJson(doc.data());
      }).toList();
    } catch (e) {
      // Return empty list on error so app doesn't crash
      return [];
    }
  }

  /// Searches recipes using a Hybrid Strategy.
  /// 1. Comma in query? -> Ingredient Search (Cheap)
  /// 2. Text in query? -> Complex Search (Standard)
  Future<List<Recipe>> searchRecipes(String query, FilterState filters) async {
    if (query.contains(',')) {
      return _searchByIngredients(query);
    } else {
      return _searchComplex(query, filters);
    }
  }

  /// Gets full recipe details.
  /// Logic: Checks Cache -> If "Full" (has ingredients), return it.
  /// If "Lite" (no ingredients) or Missing, fetch from API & update cache.
  Future<Recipe> getRecipeDetails(int recipeId) async {
    final cacheDoc = _firestore.collection('recipes').doc(recipeId.toString());
    final snapshot = await cacheDoc.get();

    // 1. Check Cache
    if (snapshot.exists && snapshot.data() != null) {
      final cachedRecipe = Recipe.fromSpoonacularJson(snapshot.data()!);

      // SMART CHECK: If it has ingredients, it's a Full Record.
      if (cachedRecipe.ingredients.isNotEmpty) {
        return cachedRecipe; // Return immediately (0 Cost)
      }
      // If ingredients are empty, it's a "Lite" record from a cheap search.
      // We fall through to fetch the full details below.
    }

    // 2. Fetch Full Details from API (1 Point)
    final recipeJson = await _fetchFromSpoonacular(recipeId);

    // 3. Save to Cache (Upgrades Lite -> Full)
    await cacheDoc.set(recipeJson);

    return Recipe.fromSpoonacularJson(recipeJson);
  }

  // ===========================================================================
  // 🟡 PRIVATE HELPERS (Internal Logic)
  // ===========================================================================

  /// Option A: Ingredient Search (e.g. "apple,flour")
  /// Returns recipes that match ingredients. (No Time/Rating data)
  Future<List<Recipe>> _searchByIngredients(String ingredients) async {
    final uri = Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?apiKey=$_spoonacularApiKey&ingredients=$ingredients&number=10&ranking=2&ignorePantry=true');

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Map raw list to Recipe objects
      return data.map((json) {
        return Recipe(
          id: json['id'],
          title: json['title'],
          image: json['image'],
          rating: null,
          time: null,
          // Capture used/missed counts for the UI badges
          usedIngredientCount: json['usedIngredientCount'] ?? 0,
          missedIngredientCount: json['missedIngredientCount'] ?? 0,
        );
      }).toList();
    } else {
      throw Exception('Ingredient search failed: ${response.statusCode}');
    }
  }

  /// Option B: Text/Filter Search (e.g. "Pasta", "Keto")
  /// Uses "Cheap Mode" (number=20, no details) to save quota.
  Future<List<Recipe>> _searchComplex(String query, FilterState filters) async {
    var queryString = 'apiKey=$_spoonacularApiKey&query=$query&number=20';

    // Apply Filters
    if (filters.sortBy.isNotEmpty) {
      switch (filters.sortBy) {
        case 'Prep Time':
          queryString += '&sort=time&sortDirection=asc';
          break;
        case 'Ratings':
          queryString += '&sort=popularity';
          break;
        case 'Servings':
          queryString += '&sort=servings&sortDirection=asc';
          break;
      }
    }
    if (filters.cuisines.isNotEmpty) {
      queryString += '&cuisine=${filters.cuisines.join(',')}';
    }
    if (filters.tags.isNotEmpty) {
      queryString += '&diet=${filters.tags.join(',')}';
    }

    final uri = Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?$queryString');

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      // Cache these results to Firestore so they appear in "Recent" lists
      final batch = _firestore.batch();
      List<Recipe> recipes = [];

      for (var result in results) {
        final recipe =
            Recipe.fromSpoonacularJson(result as Map<String, dynamic>);
        recipes.add(recipe);

        final docRef =
            _firestore.collection('recipes').doc(recipe.id.toString());
        batch.set(docRef, result);
      }
      await batch.commit();

      return recipes;
    } else {
      throw Exception('Search failed: ${response.statusCode}');
    }
  }

  /// Helper to fetch single recipe details
  Future<Map<String, dynamic>> _fetchFromSpoonacular(int recipeId) async {
    final uri = Uri.parse(
        'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$_spoonacularApiKey&includeNutrition=false');

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load recipe: ${response.statusCode}');
    }
  }
}

// --- PROVIDER ---
final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService();
});
