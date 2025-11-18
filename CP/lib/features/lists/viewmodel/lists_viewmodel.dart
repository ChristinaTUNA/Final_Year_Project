import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/list_item.dart';
import '../../../data/services/shopping_service.dart';
import 'lists_state.dart';

final listsViewModelProvider =
    NotifierProvider<ListsViewModel, ListsState>(ListsViewModel.new);

class ListsViewModel extends Notifier<ListsState> {
  late ShoppingService _shoppingService;

  @override
  ListsState build() {
    _shoppingService = ref.watch(shoppingServiceProvider);
    _shoppingService.addListener(onShoppingServiceChange);

    ref.onDispose(() {
      _shoppingService.removeListener(onShoppingServiceChange);
    });

    return ListsState(shoppingItems: _shoppingService.items);
  }

  void onShoppingServiceChange() {
    state = state.copyWith(shoppingItems: _shoppingService.items);
  }

  void changeTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  void toggleDone(int index) {
    if (state.selectedTab == 0) {
      _shoppingService.toggleDone(index);
    } else {
      final newPantry = List<ListItem>.from(state.pantryItems);
      newPantry[index] =
          newPantry[index].copyWith(done: !newPantry[index].done);
      state = state.copyWith(pantryItems: newPantry);
    }
  }

  void addItem(ListItem item) {
    if (state.selectedTab == 0) {
      _shoppingService.addItem(item);
    } else {
      state = state.copyWith(pantryItems: [...state.pantryItems, item]);
    }
  }
}
