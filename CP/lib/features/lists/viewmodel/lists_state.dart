import '../../../data/models/list_item.dart';

class ListsState {
  final int selectedTab; // 0 = Shopping, 1 = Pantry
  final List<ListItem> shoppingItems;
  final List<ListItem> pantryItems;

  const ListsState({
    this.selectedTab = 0,
    this.shoppingItems = const [],
    this.pantryItems = const [],
  });

  List<ListItem> get currentList =>
      selectedTab == 0 ? shoppingItems : pantryItems;

  ListsState copyWith({
    int? selectedTab,
    List<ListItem>? shoppingItems,
    List<ListItem>? pantryItems,
  }) {
    return ListsState(
      selectedTab: selectedTab ?? this.selectedTab,
      shoppingItems: shoppingItems ?? this.shoppingItems,
      pantryItems: pantryItems ?? this.pantryItems,
    );
  }
}
