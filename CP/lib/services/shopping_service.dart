import 'package:flutter/foundation.dart';
import '../models/shopping_item.dart';

class ShoppingService extends ChangeNotifier {
  ShoppingService._privateConstructor();

  static final ShoppingService _instance =
      ShoppingService._privateConstructor();

  static ShoppingService get instance => _instance;

  final List<ShoppingItem> _items = [];

  List<ShoppingItem> get items => List.unmodifiable(_items);

  void addAll(List<ShoppingItem> items) {
    _items.addAll(items);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void toggleDone(int index) {
    final it = _items[index];
    _items[index] = it.copyWith(done: !it.done);
    notifyListeners();
  }
}
