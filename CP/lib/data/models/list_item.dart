class ListItem {
  final String name;
  final String? quantity;
  final String? brand;
  final bool done;

  ListItem({
    required this.name,
    this.quantity,
    this.brand,
    this.done = false,
  });

  ListItem copyWith({
    String? name,
    String? quantity,
    String? brand,
    bool? done,
  }) {
    return ListItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      brand: brand ?? this.brand,
      done: done ?? this.done,
    );
  }

  // optional for Firebase integration
  factory ListItem.fromJson(Map<String, dynamic> json) => ListItem(
        name: json['name'],
        quantity: json['quantity'],
        brand: json['brand'],
        done: json['done'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'brand': brand,
        'done': done,
      };
}
