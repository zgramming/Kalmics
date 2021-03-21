import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import '../../provider/my_provider.dart';
import '../onboarding/onboarding_screen.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read(settingProvider).readSettingProvider();
    });

    _sizeController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _sizeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _sizeController, curve: Curves.fastOutSlowIn));
    _sizeController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (_, watch, __) {
          final setting = watch(settingProvider.state);
          return SizeTransition(
            sizeFactor: _sizeAnimation,
            axis: Axis.horizontal,
            child: SplashScreenTemplate(
              backgroundColor: colorPallete.primaryColor,
              image: ShowImageAsset(
                imageUrl: "${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}",
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
