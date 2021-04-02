import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/my_config.dart';
import '../../provider/my_provider.dart';
import '../welcome/welcome_screen.dart';

class OnboardingScreen extends StatelessWidget {
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
            colors: [
              ...ConstColor.backgroundColorGradient(),
            ],
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
              Navigator.of(context).pushNamed(WelcomeScreen.routeNamed);
            }).catchError((error) {
              context.read(isLoading).state = false;
              GlobalFunction.showSnackBar(context,
                  content: Text(error.toString()), snackBarType: SnackBarType.error);
            });
          },
          items: [
            OnboardingItem(
              logo: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  '${appConfig.urlImageAsset}/${ConstString.assetIconMusic}',
                  fit: BoxFit.cover,
                ),
              ),
              title: 'Tampilan Musik Kekinian',
              subtitle: '',
              titleStyle: GoogleFonts.montserrat(
                fontSize: sizes.width(context) / 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              subtitleStyle: GoogleFonts.openSans(
                fontSize: sizes.width(context) / 30,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            OnboardingItem(
              logo: Image.asset(
                '${appConfig.urlImageAsset}/${ConstString.assetIconChart}',
                fit: BoxFit.cover,
              ),
              title: 'Fitur-fitur yang menarik',
              titleStyle: GoogleFonts.montserrat(
                fontSize: sizes.width(context) / 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              subtitle: "",
              subtitleStyle: GoogleFonts.openSans(
                fontSize: sizes.width(context) / 30,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            OnboardingItem(
              logo: Image.asset(
                '${appConfig.urlImageAsset}/${ConstString.assetIconPersonListen}',
                fit: BoxFit.cover,
              ),
              title: 'Mainkan lagu pertamamu',
              titleStyle: GoogleFonts.montserrat(
                fontSize: sizes.width(context) / 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              subtitle: "",
              subtitleStyle: GoogleFonts.openSans(
                fontSize: sizes.width(context) / 30,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
