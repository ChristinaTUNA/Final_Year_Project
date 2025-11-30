import 'package:cookit/data/models/list_item.dart';
import 'package:cookit/data/services/recognition_service.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/scanned_ingredient.dart';

// --- STATE ---
class ScanState {
  final XFile? image;
  final List<ScannedIngredient>? ingredients;
  final Set<String> selectedIngredients;

  const ScanState(
      {this.image, this.ingredients, this.selectedIngredients = const {}});

  ScanState copyWith({
    XFile? image,
    List<ScannedIngredient>? ingredients,
    Set<String>? selectedIngredients,
  }) {
    return ScanState(
      image: image ?? this.image,
      ingredients: ingredients ?? this.ingredients,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
    );
  }
}

//  Use autoDispose so state clears when you leave the screen
final scanViewModelProvider =
    AsyncNotifierProvider.autoDispose<ScanViewModel, ScanState>(
        () => ScanViewModel());

// --- VIEWMODEL ---
class ScanViewModel extends AutoDisposeAsyncNotifier<ScanState> {
  @override
  Future<ScanState> build() async {
    return const ScanState();
  }

  Future<void> analyzeImage(XFile imageFile) async {
    // 1. Show image immediately, clear old data
    state = AsyncData(ScanState(image: imageFile, ingredients: null));

    // 2. Set loading state while keeping the image visible
    state = const AsyncLoading<ScanState>().copyWithPrevious(state);

    // 3. Call API
    state = await AsyncValue.guard(() async {
      final ingredients = await ref
          .read(imageRecognitionServiceProvider)
          .analyzeImage(imageFile);

      // Auto-select all ingredients by default
      final allNames = ingredients.map((e) => e.name).toSet();

      return ScanState(
        image: imageFile,
        ingredients: ingredients,
        selectedIngredients: allNames,
      );
    });
  }

  //  Toggle selection when user taps a chip
  void toggleSelection(String name) {
    final current = Set<String>.from(state.value?.selectedIngredients ?? {});
    if (current.contains(name)) {
      current.remove(name);
    } else {
      current.add(name);
    }
    state = AsyncData(state.value!.copyWith(selectedIngredients: current));
  }

  // Add a manual item if scanning missed something
  void addManualIngredient(String name) {
    if (state.value?.ingredients == null) return;

    final currentList = List<ScannedIngredient>.from(state.value!.ingredients!);
    // Check duplicates (case insensitive)
    if (!currentList.any((i) => i.name.toLowerCase() == name.toLowerCase())) {
      currentList.add(
          ScannedIngredient(name: name, category: 'Manual', quantity: '1'));

      // Auto-select the new item
      final currentSelection =
          Set<String>.from(state.value!.selectedIngredients)..add(name);

      state = AsyncData(state.value!.copyWith(
          ingredients: currentList, selectedIngredients: currentSelection));
    }
  }

  //  Logic to save selected items to Firebase Pantry
  Future<int> addToPantry() async {
    final ingredients = state.value?.ingredients;
    final selected = state.value?.selectedIngredients;

    if (ingredients == null || selected == null || selected.isEmpty) return 0;

    // Filter only selected items
    final itemsToAdd = ingredients
        .where((i) => selected.contains(i.name))
        .map((i) =>
            ListItem(name: i.name, category: i.category, quantity: i.quantity))
        .toList();

    // Call Database Service
    await ref.read(userDatabaseServiceProvider).addItems(itemsToAdd, 'pantry');

    return itemsToAdd.length;
  }

  void clearScan() {
    state = const AsyncData(ScanState());
  }
}
