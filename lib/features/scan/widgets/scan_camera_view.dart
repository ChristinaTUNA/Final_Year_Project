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

  // New State for Flash and Zoom
  FlashMode _flashMode = FlashMode.off;
  double _currentZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      _controller = CameraController(
        _cameras.first,
        ResolutionPreset.high, // High is good balance for quality/speed
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      // Get zoom capabilities
      _maxZoomLevel = await _controller!.getMaxZoomLevel();

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

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
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

  // Toggle Flash
  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    FlashMode newMode;
    if (_flashMode == FlashMode.off) {
      newMode = FlashMode.torch; // Torch is better for scanning than 'auto'
    } else {
      newMode = FlashMode.off;
    }

    await _controller!.setFlashMode(newMode);
    setState(() {
      _flashMode = newMode;
    });
  }

  // Handle Tap to Focus
  void _onTapToFocus(TapDownDetails details, BoxConstraints constraints) {
    if (_controller == null) return;
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    _controller!.setFocusPoint(offset);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera Preview with Tap-to-Focus
          GestureDetector(
            onTapDown: (details) => _onTapToFocus(details, constraints),
            // Use Transform.scale to cover full screen if aspect ratio differs
            // But standard CameraPreview is usually fine for this use case
            child: CameraPreview(_controller!),
          ),

          // 2. Flash Button (Top Right)
          Positioned(
            top: 50,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.4),
              child: IconButton(
                icon: Icon(
                  _flashMode == FlashMode.off
                      ? Icons.flash_off
                      : Icons.flash_on,
                  color: _flashMode == FlashMode.off
                      ? Colors.white
                      : Colors.yellow,
                ),
                onPressed: _toggleFlash,
              ),
            ),
          ),

          // 3. Zoom Slider (Right Side) - Optional but pro
          Positioned(
            right: 16,
            top: 120,
            bottom: 120,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: _currentZoomLevel,
                min: 1.0,
                max: _maxZoomLevel > 5.0 ? 5.0 : _maxZoomLevel, // Cap at 5x
                activeColor: AppColors.primary,
                inactiveColor: Colors.white30,
                onChanged: (value) {
                  setState(() {
                    _currentZoomLevel = value;
                    _controller!.setZoomLevel(value);
                  });
                },
              ),
            ),
          ),

          // 4. Controls Overlay (Bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery Button
                  IconButton(
                    onPressed: widget.onGalleryPressed,
                    icon: const Icon(Icons.photo_library,
                        color: Colors.white, size: 32),
                  ),

                  // Shutter Button (Enhanced Visual)
                  GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Placeholder to balance layout (or switch camera)
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
