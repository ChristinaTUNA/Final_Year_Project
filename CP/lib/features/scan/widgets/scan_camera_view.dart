import 'package:camera/camera.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ScanCameraView extends StatefulWidget {
  final Function(XFile) onPictureTaken;
  final VoidCallback onGalleryPressed;

  const ScanCameraView({
    super.key,
    required this.onPictureTaken,
    required this.onGalleryPressed,
  });

  @override
  State<ScanCameraView> createState() => _ScanCameraViewState();
}

class _ScanCameraViewState extends State<ScanCameraView>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    // Register this widget to listen for app lifecycle events (background/foreground)
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      // Initialize the first camera (usually back camera)
      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // When the app is inactive, dispose of the controller and set it to null.
      cameraController.dispose().then((_) {
        if (!mounted) return;
        setState(() => _isCameraInitialized = false);
      });
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    try {
      final XFile file = await _controller!.takePicture();
      widget.onPictureTaken(file);
    } catch (e) {
      debugPrint("Error taking picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Camera Preview
        // We wrap it in a Center/AspectRatio to prevent distortion if needed,
        // but CameraPreview handles most cases well.
        CameraPreview(_controller!),

        // 2. Controls Overlay (Bottom)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(bottom: 40, top: 20),
            color: Colors.black.withValues(alpha: 0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery Button
                IconButton(
                  onPressed: widget.onGalleryPressed,
                  icon: const Icon(Icons.photo_library,
                      color: Colors.white, size: 32),
                ),

                // Shutter Button
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.transparent,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),

                // Placeholder to balance the row (or Flash toggle later)
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
