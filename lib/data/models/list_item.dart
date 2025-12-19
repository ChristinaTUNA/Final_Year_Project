class ListItem {
  final String id; // Useful for Firestore updates/deletes
  final String name;
  final String? quantity;
  final bool done;
  final String? category; // e.g., "Pantry" or "Shopping"

  ListItem({
    String? id,
    required this.name,
    this.quantity,
    this.done = false,
    this.category,
  }) : id = id ?? name; // Use name as ID if null (simple approach)

  /// Convert ListItem to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'done': done,
      'category': category,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Factory constructor to create ListItem from Firestore document
  factory ListItem.fromMap(Map<String, dynamic> map, String docId) {
    return ListItem(
      id: docId,
      name: map['name'] ?? '',
      quantity: map['quantity'],
      done: map['done'] ?? false,
      category: map['category'],
    );
  }

// Create a copy with modified fields
  ListItem copyWith({bool? done, String? quantity}) {
    return ListItem(
      id: id,
      name: name,
      quantity: quantity ?? this.quantity,
      done: done ?? this.done,
      category: category,
    );
  }
}
