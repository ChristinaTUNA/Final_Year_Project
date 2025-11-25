import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/scanned_ingredient.dart';
import '../../../data/services/gemini_service.dart';

/// This "brain" manages the state for the ScanScreen.
/// It holds the loading/error/data state for the API call.
final scanViewModelProvider =
    AsyncNotifierProvider<ScanViewModel, List<ScannedIngredient>?>(
  () => ScanViewModel(),
);

class ScanViewModel extends AsyncNotifier<List<ScannedIngredient>?> {
  @override
  Future<List<ScannedIngredient>?> build() async {
    // Default to a null state (no results yet)
    return null;
  }

  /// Triggers the Gemini API call.
  Future<void> analyzeImage(XFile imageFile) async {
    // 1. Set state to loading
    state = const AsyncLoading();

    // 2. Call the service
    state = await AsyncValue.guard(() async {
      return ref.read(geminiServiceProvider).analyzeImage(imageFile);
    });
  }

  /// Resets the provider back to the initial null state.
  void clearScan() {
    state = const AsyncData(null);
  }
}
