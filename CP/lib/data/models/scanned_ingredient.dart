class ScannedIngredient {
  final String name;
  final String category;

  ScannedIngredient({required this.name, required this.category});

  factory ScannedIngredient.fromJson(Map<String, dynamic> json) {
    return ScannedIngredient(
      name: json['name'] as String? ?? 'Unknown',
      category: json['category'] as String? ?? 'Uncategorized',
    );
  }
}
