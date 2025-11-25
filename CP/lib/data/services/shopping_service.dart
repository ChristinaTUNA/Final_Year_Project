// import '../models/list_item.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final shoppingServiceProvider =
//     ChangeNotifierProvider((ref) => ShoppingService());

// class ShoppingService extends ChangeNotifier {
//   ShoppingService();

//   final List<ListItem> _items = [];

//   List<ListItem> get items => List.unmodifiable(_items);
// /// Adds a single item to the shopping list
//   void addItem(ListItem item) {
//     _items.add(item);
//     notifyListeners();
//   }
// //
//   void addAll(List<ListItem> items) {
//     _items.addAll(items);
//     notifyListeners();
//   }

//   void toggleDone(int index) {
//     _items[index] = _items[index].copyWith(done: !_items[index].done);
//     notifyListeners();
//   }

//   void clearAll() {
//     _items.clear();
//     notifyListeners();
//   }

//   // for future Firebase: connect here
//   Future<void> loadFromFirebase() async {
//     // TODO
//   }
// }
