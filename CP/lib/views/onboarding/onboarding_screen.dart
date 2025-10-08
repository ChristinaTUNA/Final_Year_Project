import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/onboarding_model.dart';
import '../../viewmodels/onboarding_viewmodel.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingProvider);
    final viewModel = ref.read(onboardingProvider.notifier);
    final onboardingData = viewModel.pages;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- Page View ---
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) =>
                viewModel.setPage(index), // sync Riverpod state
            itemCount: onboardingData.length,
            itemBuilder: (context, index) =>
                _buildOnboardingPage(onboardingData[index]),
          ),

          // --- Back Button ---
          Positioned(
            top: 50, // adjust this depending on your UI
            left: 16,
            child: SafeArea(
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                onPressed: () {
                  if (currentPage > 0) {
                    // Move to previous onboarding page
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    viewModel.setPage(currentPage - 1);
                  } else {
                    // Exit onboarding if on the first page
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),

          // --- Bottom Section ---
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        onboardingData[currentPage].title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF181725),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        onboardingData[currentPage].description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFF7C7C7C),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // --- Dots Indicator ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(onboardingData.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: index == currentPage ? 16 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: index == currentPage
                                  ? const Color(0xFFE02200)
                                  : const Color(0xFFE0E0E0),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 32),

                      // --- Buttons ---
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                viewModel.skipToEnd();
                                _pageController.animateToPage(
                                  onboardingData.length - 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Text(
                                'Skip',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE02200),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (currentPage < onboardingData.length - 1) {
                                    viewModel.nextPage();
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE02200),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  currentPage == onboardingData.length - 1
                                      ? 'Start Cooking!'
                                      : 'Continue',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds each onboarding page (image + layout)
  Widget _buildOnboardingPage(OnboardingData data) {
    return Container(
      color: data.backgroundColor,
      alignment: data.alignment,
      child: Image.asset(
        data.imagePath,
        width: data.width,
        height: data.height,
        fit: BoxFit.contain,
      ),
    );
  }
}
