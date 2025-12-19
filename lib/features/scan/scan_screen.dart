import 'dart:io';
import 'package:cookit/features/scan/scan_result_sheet.dart';
import 'package:cookit/features/scan/scan_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/scan_camera_view.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    try {
      final imageFile = await picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        ref.read(scanViewModelProvider.notifier).analyzeImage(imageFile);
      }
    } catch (e) {
      // Handle any errors here, e.g., show a snackbar
      debugPrint('Error picking image from gallery: $e');
    }
  }

  void _onPictureTaken(XFile file) {
    ref.read(scanViewModelProvider.notifier).analyzeImage(file);
  }

  // Centralized Back Navigation Logic
  void _handleBack() {
    final hasImage = ref.read(scanViewModelProvider).value?.image != null;

    if (hasImage) {
      // If viewing results, go back to Camera
      ref.read(scanViewModelProvider.notifier).clearScan();
    } else {
      // If on Camera, close screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanViewModelProvider);
    final hasImage = scanState.value?.image != null;

    // Intercept system back button (Android)
    return PopScope(
      canPop: !hasImage, // Only allow pop if we are in Camera mode
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // --- LAYER 1: Content (Camera or Image) ---
            // AnimatedSwitcher gives a nice fade effect when switching
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: hasImage
                  ? SizedBox(
                      key: const ValueKey('ImagePreview'),
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.file(
                        File(scanState.value!.image!.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : ScanCameraView(
                      key: const ValueKey('CameraView'),
                      onPictureTaken: _onPictureTaken,
                      onGalleryPressed: _pickFromGallery,
                    ),
            ),

            // --- LAYER 2: Top Controls (Back Button) ---
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black.withValues(alpha: 0.4),
                        child: IconButton(
                          // Switch icon to indicate context
                          icon: Icon(
                            hasImage ? Icons.arrow_back : Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: _handleBack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- LAYER 3: Results Sheet ---
            if (hasImage)
              const Align(
                alignment: Alignment.bottomCenter,
                child: ScanResultsSheet(),
              ),
          ],
        ),
      ),
    );
  }
}
