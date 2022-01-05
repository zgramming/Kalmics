import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../splash/widgets/onboarding_content.dart';
import '../splash/widgets/percentage_indicator.dart';

class OnboardingPage extends StatelessWidget {
  static const routeNamed = '/onboarding-page';
  const OnboardingPage({Key? key}) : super(key: key);

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
