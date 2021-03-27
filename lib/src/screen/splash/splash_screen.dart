import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../config/flutter_local_notification/flutter_local_notification.dart';
import '../../config/my_config.dart';
import '../../provider/my_provider.dart';

import '../onboarding/onboarding_screen.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  static const _logoTransparent = 'Kalmics-transparent.png';
  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;
  ConfigFlutterLocalNotification configFlutterLocalNotification = ConfigFlutterLocalNotification();

  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      context.read(settingProvider).readSettingProvider();
    });

    configFlutterLocalNotification.init(onSelectNotification: onSelectNotification);
    _sizeController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _sizeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _sizeController, curve: Curves.fastOutSlowIn));
    _sizeController.forward();

    super.initState();
  }

  Future onSelectNotification(String? payload) async {
    log('Listen OnSelectNotification $payload');
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPallete.primaryColor,
      body: Consumer(
        builder: (_, watch, __) {
          final setting = watch(settingProvider.state);
          return SizeTransition(
            sizeFactor: _sizeAnimation,
            axis: Axis.horizontal,
            child: SplashScreenTemplate(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ...ConstColor.backgroundColorGradient(),
                ],
              ),
              image: ShowImageAsset(
                imageUrl: "${appConfig.urlImageAsset}/$_logoTransparent",
              ),
              navigateAfterSplashScreen: (ctx) {
                if (setting.isPassedOnboarding) {
                  return WelcomeScreen();
                }
                return OnboardingScreen();
              },
              copyRightVersion: const CopyRightVersion(),
            ),
          );
        },
      ),
    );
  }
}
