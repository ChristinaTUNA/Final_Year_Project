import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/intro_model.dart';
import 'intro_viewmodel.dart';
import 'widgets/intro_bottomsheet.dart';
import 'widgets/intro_backbutton.dart';
import 'package:cookit/core/theme/app_colors.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: ref.read(introViewModelProvider).currentPage);

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
    final state = ref.watch(introViewModelProvider);
    final viewModel = ref.read(introViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView (Onboarding images)
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => viewModel.setPage(index),
            itemCount: state.pages.length,
            itemBuilder: (context, index) =>
                _IntroPage(data: state.pages[index]),
          ),

          // Back button
          IntroBackButton(
            onPressed: () =>
                viewModel.onBackButtonPressed(context, _pageController),
          ),

          // Buttons + dots + texts
          IntroBottomSheet(controller: _pageController),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  final IntroData data;

  const _IntroPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(data.imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.backgroundDark.withValues(alpha: 0.3),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }
}
