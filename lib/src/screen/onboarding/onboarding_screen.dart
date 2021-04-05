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
          onPageChanged: (index) {},
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
              Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed);
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
                child: Icon(
                  Icons.music_note,
                  size: sizes.width(context) / 2,
                  color: Colors.white,
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
              logo: Icon(
                Icons.tag,
                size: sizes.width(context) / 2,
                color: Colors.white,
              ),
              title: 'Fitur-fitur yang menarik',
              titleStyle: GoogleFonts.montserrat(
                fontSize: sizes.width(context) / 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            OnboardingItem(
              logo: Icon(
                Icons.play_arrow_rounded,
                size: sizes.width(context) / 2,
                color: Colors.white,
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
