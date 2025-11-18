class ShoppingItem {
  final String name;
  final String? quantity;
  final String? brand;
  final bool done;

  ShoppingItem(
      {required this.name, this.quantity, this.brand, this.done = false});

  ShoppingItem copyWith(
      {String? name, String? quantity, String? brand, bool? done}) {
    return ShoppingItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      brand: brand ?? this.brand,
      done: done ?? this.done,
    );
  }
}
