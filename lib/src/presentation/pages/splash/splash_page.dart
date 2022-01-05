import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection.dart';
import '../onboarding/onboarding_page.dart';
import '../welcome/welcome_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final _initialize = ref.watch(_initializeApplication);
          return _initialize.when(
            data: (_) {
              final session = ref.watch(sessionNotifier.select((value) => value.item));
              log('session ${session.toJson()}');
              if (session.isAlreadyOnboarding) {
                return const WelcomePage();
              } else {
                return const OnboardingPage();
              }
            },
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

final _initializeApplication = FutureProvider.autoDispose<bool>((ref) async {
  final session = ref.watch(sessionNotifier.notifier);

  /// Initialize Session
  session.get();

  return true;
});
