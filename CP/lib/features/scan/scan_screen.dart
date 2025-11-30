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
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      ref.read(scanViewModelProvider.notifier).analyzeImage(imageFile);
    }
  }

  void _onPictureTaken(XFile file) {
    ref.read(scanViewModelProvider.notifier).analyzeImage(file);
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanViewModelProvider);

    // 1. IDLE STATE: Show Camera View (No image taken yet)
    if (scanState.value?.image == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ScanCameraView(
              onPictureTaken: _onPictureTaken,
              onGalleryPressed: _pickFromGallery,
            ),
            Positioned(
              top: 50,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      );
    }

    // 2. RESULTS STATE: Show Image + Bottom Sheet
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- LAYER 1: The Image (Top Half) ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Image.file(
              File(scanState.value!.image!.path),
              fit: BoxFit.cover,
            ),
          ),

          // --- LAYER 2: Back Button (Top Overlay) ---
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: .3),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    ref.read(scanViewModelProvider.notifier).clearScan(),
              ),
            ),
          ),

          // --- LAYER 3: The Modular Results Sheet (Bottom Half) ---
          const Align(
            alignment: Alignment.bottomCenter,
            child: ScanResultsSheet(),
          ),
        ],
      ),
    );
  }
}
