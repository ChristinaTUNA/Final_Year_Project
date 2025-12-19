class ScannedIngredient {
  final String name;
  final String category;
  final String quantity;

  ScannedIngredient(
      {required this.name, required this.category, this.quantity = '1'});

  factory ScannedIngredient.fromJson(Map<String, dynamic> json) {
    return ScannedIngredient(
      name: json['name'] as String? ?? 'Unknown',
      category: json['category'] as String? ?? 'Uncategorized',
      quantity: json['quantity'] as String? ?? '1',
    );
  }
}
