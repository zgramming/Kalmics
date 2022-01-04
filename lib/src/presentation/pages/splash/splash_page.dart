import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/onboarding_content.dart';
import 'widgets/percentage_indicator.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          PercetageIndicator(),
          OnboardingContent(),
        ],
      ),
    );
  }
}

final currentIndexOnboarding = StateProvider.autoDispose((ref) => 0);

final currentPercetageOnboarding = Provider.autoDispose<double>((ref) {
  const totalPage = 3;
  final _currentIndex = ref.watch(currentIndexOnboarding) + 1;
  final percentage = 100 / (totalPage / _currentIndex);
  return percentage / 100;
});
