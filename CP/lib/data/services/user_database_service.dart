import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/data/models/list_item.dart';
import 'package:cookit/data/models/user_preferences_model.dart';
import 'package:cookit/data/models/recipe_model.dart';

class UserDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper to get current User ID safely
  String? get _userId => _auth.currentUser?.uid;

  // --- 1. PREFERENCES ---

  Future<void> savePreferences(UserPreferences prefs) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('settings')
        .doc('preferences')
        .set(prefs.toMap());
  }

  Future<UserPreferences> getPreferences() async {
    if (_userId == null) return const UserPreferences();
    final doc = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('settings')
        .doc('preferences')
        .get();

    if (doc.exists) {
      return UserPreferences.fromMap(doc.data()!);
    }
    return const UserPreferences(); // Return defaults
  }

  // --- 2. PANTRY & SHOPPING LISTS ---
  /// Adds a list of items to a collection (Pantry or Shopping List)
  Future<void> addItems(List<ListItem> items, String collectionName) async {
    if (_userId == null) return;
    final batch = _firestore.batch();

    for (var item in items) {
      final docRef = _firestore
          .collection('users')
          .doc(_userId)
          .collection(collectionName)
          .doc(item.name.toLowerCase());

      batch.set(docRef, item.toMap());
    }

    await batch.commit();
  }

  /// Gets a stream of ListItems from the list collection
  Stream<List<ListItem>> getListStream(String collectionName) {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection(collectionName)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ListItem.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Toggles the 'done' status of an item
  Future<void> toggleItemDone(
      String collectionName, String itemId, bool currentStatus) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection(collectionName)
        .doc(itemId)
        .update({'done': !currentStatus});
  }

  /// Deletes an item from the specified collection
  Future<void> deleteItem(String collectionName, String itemId) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection(collectionName)
        .doc(itemId)
        .delete();
  }

  // --- 3. SAVED RECIPES (FAVORITES) ---

  /// Toggles a recipe as favorite (Add if not exists, Remove if exists)
  Future<void> toggleFavorite(Recipe recipe) async {
    if (_userId == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(recipe.id.toString());

    final doc = await docRef.get();

    if (doc.exists) {
      // If it exists, remove it (Toggle OFF)
      await docRef.delete();
    } else {
      // If it doesn't exist, add it (Toggle ON)
      // We save a summary of the recipe for display in lists
      await docRef.set({
        'id': recipe.id,
        'title': recipe.title,
        'image': recipe.image,
        'rating': recipe.rating,
        'time': recipe.time,
        'subtitle1': recipe.subtitle1,
        'subtitle2': recipe.subtitle2,
        'savedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Checks if a recipe is currently saved (for the bookmark icon)
  Stream<bool> isFavoriteStream(int recipeId) {
    if (_userId == null) return Stream.value(false);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(recipeId.toString())
        .snapshots()
        .map((doc) => doc.exists);
  }

  /// Gets all saved recipes for the user
  Stream<List<Recipe>> getFavoritesStream() {
    if (_userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Manually reconstruct the Recipe object from the summary data
        return Recipe(
          id: data['id'] as int,
          title: data['title'] as String,
          image: data['image'] as String,
          rating: (data['rating'] as num?)?.toDouble(),
          time: data['time'] as String?,
          subtitle1: data['subtitle1'] as String?,
          subtitle2: data['subtitle2'] as String?,
          // Initialize empty lists for details (fetched only when clicked)
          ingredients: [],
          instructions: [],
        );
      }).toList();
    });
  }
}

// --- PROVIDER ---
final userDatabaseServiceProvider = Provider<UserDatabaseService>((ref) {
  return UserDatabaseService();
});
