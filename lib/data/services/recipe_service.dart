import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/models/filter_state.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final http.Client _client = http.Client();
  final String _spoonacularApiKey = dotenv.env['SPOONACULAR_API_KEY'] ?? '';

  /// Fetches cached recipes from Firebase Firestore.
  Future<List<Recipe>> getCachedRecipes() async {
    try {
      final snapshot = await _firestore.collection('recipes').limit(30).get();
      if (snapshot.docs.isEmpty) return [];
      return snapshot.docs
          .map((doc) => Recipe.fromSpoonacularJson(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Searches recipes using a Hybrid Strategy.
  /// 1. Comma in query? -> Ingredient Search (Cheap)
  /// 2. Text in query? -> Complex Search (Standard)
  Future<List<Recipe>> searchRecipes(String query, FilterState filters,
      {int offset = 0}) async {
    final bool isIngredientSearch = query.contains(',');

    if (isIngredientSearch) {
      // Ingredient search doesn't support offset well in this endpoint,
      // so we stop pagination for it to prevent duplicates.
      if (offset > 0) return [];
      return _searchByIngredients(query);
    } else {
      return _searchComplex(query, filters, offset);
    }
  }

  Future<List<Recipe>> _searchByIngredients(String ingredients) async {
    final uri = Uri.parse(
        'https://api.spoonacular.com/recipes/findByIngredients?apiKey=$_spoonacularApiKey&ingredients=$ingredients&number=10&ranking=2&ignorePantry=true');

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        return Recipe(
          id: json['id'],
          title: json['title'],
          image: json['image'],
          rating: null,
          time: null,
          usedIngredientCount: json['usedIngredientCount'] ?? 0,
          missedIngredientCount: json['missedIngredientCount'] ?? 0,
        );
      }).toList();
    } else {
      throw Exception('Ingredient search failed: ${response.statusCode}');
    }
  }

  Future<List<Recipe>> _searchComplex(
      String query, FilterState filters, int offset) async {
    // Add &offset=$offset to the URL
    var queryString =
        'apiKey=$_spoonacularApiKey&query=$query&number=20&offset=$offset';

    if (filters.sortBy.isNotEmpty) {
      switch (filters.sortBy) {
        case 'Prep Time':
          queryString += '&sort=time&sortDirection=asc';
          break;
        case 'Ratings':
          queryString += '&sort=popularity';
          break;
        case 'Popularity':
          queryString += '&sort=popularity';
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

  /// Gets full recipe details.
  /// Logic: Checks Cache -> If "Full" (has ingredients), return it.
  /// If "Lite" (no ingredients) or Missing, fetch from API & update cache.
  Future<Recipe> getRecipeDetails(int recipeId) async {
    final cacheDoc = _firestore.collection('recipes').doc(recipeId.toString());
    final snapshot = await cacheDoc.get();

    if (snapshot.exists && snapshot.data() != null) {
      final cached = Recipe.fromSpoonacularJson(snapshot.data()!);
      if (cached.ingredients.isNotEmpty) return cached;
    }

    final recipeJson = await _fetchFromSpoonacular(recipeId);
    await cacheDoc.set(recipeJson);
    return Recipe.fromSpoonacularJson(recipeJson);
  }

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
