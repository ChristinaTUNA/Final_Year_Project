import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/welcome_viewmodel.dart';
import 'widgets/welcome_body.dart';
import 'widgets/welcome_header.dart';
import 'widgets/welcome_button.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Delay ViewModel init to avoid provider modification during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(welcomeViewModelProvider).init(this);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(welcomeViewModelProvider);

    if (!viewModel.initialized) {
      return const Scaffold(
        backgroundColor: Color(0xFFFBF1C7),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBF1C7),
      body: Stack(
        children: [
          // Top-left big white circle
          Positioned(
            top: -180,
            right: 40,
            child: Container(
              width: 560,
              height: 560,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Header top-left
          const Positioned(
            top: 50,
            left: 32,
            child: WelcomeHeader(),
          ),
          // Body center-right
          const Positioned(
            bottom: 220,
            right: 32,
            child: WelcomeBody(),
          ),
          // Button bottom-center
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: WelcomeButton(
                viewModel: viewModel,
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
