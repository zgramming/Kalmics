import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/my_config.dart';
import '../../provider/my_provider.dart';
import '../welcome/welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<Offset> translateAnimation;
  late final Animation<double> scaleAnimation;
  late final Animation<double> rotateAnimation;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));

    translateAnimation = Tween<Offset>(begin: const Offset(200, 0), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: animationController, curve: const Interval(0.1, 1)));

    scaleAnimation = Tween<double>(begin: 1, end: 1.5)
        .animate(CurvedAnimation(parent: animationController, curve: const Interval(0.7, 1)));

    rotateAnimation = Tween<double>(begin: 0, end: -0.25)
        .animate(CurvedAnimation(parent: animationController, curve: const Interval(0.9, 1)));

    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProviderListener<StateController<bool>>(
        provider: isLoading,
        onChange: (context, value) {
          if (value.state) {
            GlobalFunction.showDialogLoading(context, title: 'Proses Scanning Lagu');
            return;
          }
          Navigator.of(context).pop();
        },
        child: OnboardingPage(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ConstColor.backgroundColorGradient(),
          ),
          onPageChanged: (index) {
            animationController.reset();
            animationController.forward();
          },
          onClickNext: (index) {},
          onClickFinish: () async {
            final permissionStorage = await Permission.storage.status;
            if (permissionStorage != PermissionStatus.granted) {
              final result = await Permission.storage.request();

              if (result == PermissionStatus.permanentlyDenied) {
                GlobalFunction.showDialogNeedAccess(
                  context,
                  onPressed: () async {
                    final result = await openAppSettings();
                    if (!result) {
                      GlobalFunction.showSnackBar(
                        context,
                        content: const Text('Tidak dapat membuka setting'),
                        snackBarType: SnackBarType.error,
                      );
                    }
                  },
                );
              }
              return;
            }
            context.read(isLoading).state = true;
            context.refresh(initializeMusicFromStorage).then((_) async {
              context.read(isLoading).state = false;
              await context
                  .read(settingProvider)
                  .setSettingOnboardingScreen(value: ConstString.finishedOnboarding);
              Navigator.of(context).pushNamed(WelcomeScreen.routeNamed);
            }).catchError((error) {
              context.read(isLoading).state = false;
              GlobalFunction.showSnackBar(context,
                  content: Text(error.toString()), snackBarType: SnackBarType.error);
            });
          },
          items: [
            OnboardingItem(
              logo: Align(
                alignment: Alignment.bottomCenter,
                child: _AnimatedBuilder(
                  animationController: animationController,
                  translateAnimation: translateAnimation,
                  scaleAnimation: scaleAnimation,
                  rotateAnimation: rotateAnimation,
                  icon: Icons.music_note,
                ),
              ),
              title: 'Tampilan Musik Kekinian',
              titleStyle: GoogleFonts.montserrat(
                fontSize: sizes.width(context) / 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            OnboardingItem(
              logo: _AnimatedBuilder(
                animationController: animationController,
                translateAnimation: translateAnimation,
                scaleAnimation: scaleAnimation,
                rotateAnimation: rotateAnimation,
                icon: Icons.tag,
              ),
              title: 'Fitur-fitur yang menarik',
              titleStyle: GoogleFonts.montserrat(
                fontSize: sizes.width(context) / 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            OnboardingItem(
              logo: _AnimatedBuilder(
                animationController: animationController,
                translateAnimation: translateAnimation,
                scaleAnimation: scaleAnimation,
                rotateAnimation: rotateAnimation,
                icon: Icons.play_arrow_rounded,
              ),
              title: 'Mainkan lagu pertamamu',
              titleStyle: GoogleFonts.montserrat(
                fontSize: sizes.width(context) / 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBuilder extends StatelessWidget {
  const _AnimatedBuilder({
    Key? key,
    required this.animationController,
    required this.translateAnimation,
    required this.scaleAnimation,
    required this.rotateAnimation,
    required this.icon,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<Offset> translateAnimation;
  final Animation<double> scaleAnimation;
  final Animation<double> rotateAnimation;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => Transform.translate(
        offset: translateAnimation.value,
        child: Transform.scale(
          scale: scaleAnimation.value,
          child: Transform.rotate(
            angle: rotateAnimation.value,
            child: Icon(
              icon,
              size: sizes.width(context) / 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
