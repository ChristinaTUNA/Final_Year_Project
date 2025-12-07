import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookit/data/models/list_item.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/models/user_preferences_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // ===========================================================================
  // 1. PREFERENCES (This was missing for you)
  // ===========================================================================

  /// Saves user preferences (Diet, Time, Servings)
  Future<void> savePreferences(UserPreferences prefs) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('settings')
        .doc('preferences')
        .set(prefs.toMap());
  }

  /// Gets user preferences. Returns default if not found.
  Future<UserPreferences> getPreferences() async {
    if (_userId == null) return const UserPreferences();

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('settings')
          .doc('preferences')
          .get();

      if (doc.exists && doc.data() != null) {
        return UserPreferences.fromMap(doc.data()!);
      }
    } catch (e) {
      // Return defaults on error
    }
    return const UserPreferences();
  }

  /// Live Stream of Preferences
  Stream<UserPreferences> getPreferencesStream() {
    if (_userId == null) return Stream.value(const UserPreferences());

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('settings')
        .doc('preferences')
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserPreferences.fromMap(doc.data()!);
      }
      return const UserPreferences();
    });
  }

  // ===========================================================================
  // 2. PANTRY & SHOPPING LISTS
  // ===========================================================================

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

  Future<void> deleteItem(String collectionName, String itemId) async {
    if (_userId == null) return;
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection(collectionName)
        .doc(itemId)
        .delete();
  }

  // ===========================================================================
  // 3. SAVED RECIPES (FAVORITES)
  // ===========================================================================

  Future<void> toggleFavorite(Recipe recipe) async {
    if (_userId == null) return;
    final docRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .doc(recipe.id.toString());
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
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
        return Recipe(
          id: data['id'] as int,
          title: data['title'] as String,
          image: data['image'] as String,
          rating: (data['rating'] as num?)?.toDouble(),
          time: data['time'] as String?,
          subtitle1: data['subtitle1'] as String?,
          subtitle2: data['subtitle2'] as String?,
          ingredients: [],
          instructions: [],
        );
      }).toList();
    });
  }

  // ===========================================================================
  // 4. HISTORY
  // ===========================================================================

  Future<void> addToHistory(Recipe recipe) async {
    if (_userId == null) return;
    final docRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('history')
        .doc(recipe.id.toString());
    await docRef.set({
      'id': recipe.id,
      'title': recipe.title,
      'image': recipe.image,
      'rating': recipe.rating,
      'time': recipe.time,
      'subtitle1': recipe.subtitle1,
      'subtitle2': recipe.subtitle2,
      'viewedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Recipe>> getHistory() async {
    if (_userId == null) return [];
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('history')
          .orderBy('viewedAt', descending: true)
          .limit(10)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Recipe(
          id: data['id'] as int,
          title: data['title'] as String,
          image: data['image'] as String,
          rating: (data['rating'] as num?)?.toDouble(),
          time: data['time'] as String?,
          subtitle1: data['subtitle1'] as String?,
          subtitle2: data['subtitle2'] as String?,
          ingredients: [],
          instructions: [],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

// --- PROVIDER ---
final userDatabaseServiceProvider = Provider<UserDatabaseService>((ref) {
  return UserDatabaseService();
});
