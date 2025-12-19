import 'dart:async';
import 'package:cookit/data/models/list_item.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- STATE ---
class ListsState extends Equatable {
  final int selectedTab; // 0 = Shopping, 1 = Pantry
  final List<ListItem> shoppingList;
  final List<ListItem> pantryList;

  const ListsState({
    this.selectedTab = 0,
    this.shoppingList = const [],
    this.pantryList = const [],
  });

  // Helper to get the list currently being shown
  List<ListItem> get currentList =>
      selectedTab == 0 ? shoppingList : pantryList;

  // Helper to get the Firestore collection name for the current tab
  String get currentCollection => selectedTab == 0 ? 'shopping_list' : 'pantry';

  ListsState copyWith({
    int? selectedTab,
    List<ListItem>? shoppingList,
    List<ListItem>? pantryList,
  }) {
    return ListsState(
      selectedTab: selectedTab ?? this.selectedTab,
      shoppingList: shoppingList ?? this.shoppingList,
      pantryList: pantryList ?? this.pantryList,
    );
  }

  @override
  List<Object?> get props => [selectedTab, shoppingList, pantryList];
}

// --- VIEWMODEL ---
class ListsViewModel extends StateNotifier<ListsState> {
  final UserDatabaseService _dbService;
  StreamSubscription? _shoppingSub;
  StreamSubscription? _pantrySub;

  ListsViewModel(this._dbService) : super(const ListsState()) {
    _initStreams();
  }

  /// Subscribes to live updates from Firestore
  void _initStreams() {
    // 1. Listen to Shopping List
    _shoppingSub = _dbService.getListStream('shopping_list').listen((items) {
      state = state.copyWith(shoppingList: items);
    });

    // 2. Listen to Pantry
    _pantrySub = _dbService.getListStream('pantry').listen((items) {
      state = state.copyWith(pantryList: items);
    });
  }

  @override
  void dispose() {
    _shoppingSub?.cancel();
    _pantrySub?.cancel();
    super.dispose();
  }

  // --- ACTIONS ---

  void changeTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  Future<void> addItem(ListItem item) async {
    // Add to the currently selected collection (Shopping or Pantry)
    // We wrap the single item in a list because addItems expects a list
    await _dbService.addItems([item], state.currentCollection);
  }

// todo: check this code for adding ingredients to shopping list
  // Future<void> addAll(List<ListItem> items) async {
  //    await _dbService.addItems(items, 'shopping_list');
  // }
  Future<void> toggleDone(int index) async {
    // 1. Get the item from the current list
    final item = state.currentList[index];

    // 2. Call the service to toggle it in Firestore
    // The service uses the item's ID to find the correct document
    await _dbService.toggleItemDone(
      state.currentCollection,
      item.id,
      item.done,
    );
  }

  Future<void> deleteItem(int index) async {
    final item = state.currentList[index];
    await _dbService.deleteItem(state.currentCollection, item.id);
  }
}

// --- PROVIDER ---
final listsViewModelProvider =
    StateNotifierProvider<ListsViewModel, ListsState>((ref) {
  final dbService = ref.watch(userDatabaseServiceProvider);
  return ListsViewModel(dbService);
});
