import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/functions/global_function.dart';

import '../../../../../injection.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/exception.dart';
import '../../../../utils/fonts.dart';
import '../../../../utils/navigation.dart';
import '../../../../utils/services.dart';
import '../../../widgets/mbs_storage_denied_permanent.dart';
import '../../onboarding/onboarding_page.dart';
import '../../welcome/welcome_page.dart';
import 'onboarding_item.dart';

class OnboardingContent extends StatefulWidget {
  const OnboardingContent({Key? key}) : super(key: key);
  @override
  State<OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<OnboardingContent> {
  late final PageController _pageController;

  final items = const <Widget>[
    OnboardingItem(
      title: 'Memutar Musik',
      subtitle: 'Putar musik kesukaanmu kapanpun dan dimanapun',
    ),
    OnboardingItem(
      title: 'Kirim & Pamerkan',
      subtitle: 'Kirim-kirim lagu dan pamerkan yang sedang kamu mainkan',
    ),
    OnboardingItem(
      title: 'Enjoy & Relax',
      subtitle: 'Ayo mulai dengarkan lagu pertama kamu',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                return PageView.builder(
                  controller: _pageController,
                  itemCount: items.length,
                  onPageChanged: (index) =>
                      ref.read(currentIndexOnboarding.state).update((state) => index),
                  itemBuilder: (context, index) => items[index],
                );
              },
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final _currentPage = ref.watch(currentIndexOnboarding) + 1;
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () async {
                    /// Get Current Index Onboarding
                    final _currentIndex = ref.watch(currentIndexOnboarding.notifier).state;
                    final nextIndex = _currentIndex + 1;

                    /// Check if next index less than items length
                    if (nextIndex < items.length) {
                      /// Animate to next pageview
                      _pageController.animateToPage(
                        _currentIndex + 1,
                        duration: kThemeAnimationDuration,
                        curve: Curves.ease,
                      );
                      ref.read(currentIndexOnboarding.state).update((state) => state + 1);
                    } else {
                      /// Navigate to new screen
                      /// in this state, we should first get permission storage
                      /// when granted, we should save session onboarding then navigate to [welcomePage]

                      try {
                        final isGrantedStoragePermission = await services.getPermissionStorage();
                        if (isGrantedStoragePermission) {
                          await ref
                              .read(sessionNotifier.notifier)
                              .setSessionOnboarding(value: true);

                          await globalNavigation.pushNamedAndRemoveUntil(
                            routeName: WelcomePage.routeNamed,
                            predicate: (route) => false,
                          );
                        }
                      } on StoragePermissionDeniedPermanent catch (e) {
                        final message = e.message;
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) => MBSStorageDeniedPermanent(message: message),
                        );
                      } catch (e) {
                        GlobalFunction.showSnackBar(
                          context,
                          content: Text(
                            e.toString(),
                            style: amiko.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          snackBarType: SnackBarType.error,
                        );
                        log('error cant get permission [denied/restrict/limited]');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    onPrimary: primary,
                  ),
                  child: Text(
                    _currentPage < items.length ? 'Lanjut' : 'Mulai',
                    style: amikoPrimary.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
