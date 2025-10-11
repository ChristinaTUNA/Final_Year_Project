import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/onboarding_viewmodel.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_container.dart';
import 'widgets/onboarding_backbutton.dart';

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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(onboardingProvider.notifier);
    final onboardingData = viewModel.pages;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView (Onboarding images)
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) =>
                ref.read(onboardingProvider.notifier).setPage(index),
            itemCount: onboardingData.length,
            itemBuilder: (context, index) =>
                OnboardingPage(data: onboardingData[index]),
          ),

          // Back button
          OnboardingBackbutton(
            onPressed: () {
              if (ref.read(onboardingProvider) == 0) {
                // if user is on first page → go back to WelcomeScreen
                Navigator.pop(context);
              } else {
                // if not → go to previous onboarding page
                ref
                    .read(onboardingProvider.notifier)
                    .onBackPressed(_pageController);
              }
            },
          ),

          // Buttons + dots + texts
          OnboardingButtons(controller: _pageController),
        ],
      ),
    );
  }
}
