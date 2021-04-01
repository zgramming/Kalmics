import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/config/my_config.dart';
import 'package:permission_handler/permission_handler.dart';
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
            context.refresh(futureShowListMusic).then((_) async {
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
              logo: Icon(
                Icons.design_services,
                color: Colors.white,
                size: sizes.width(context) / 1.5,
              ),
              title: 'Tampilan yang ciamik Tampilan yang ciamik Tampilan yang ciamik ',
              titleStyle: GoogleFonts.montserrat(
                fontSize: sizes.width(context) / 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              subtitle:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              subtitleStyle: GoogleFonts.openSans(
                fontSize: sizes.width(context) / 30,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            OnboardingItem(
              logo: Icon(
                Icons.music_note,
                color: Colors.white,
                size: sizes.width(context) / 1.5,
              ),
              title: 'Tampilan yang ciamik Tampilan yang ciamik Tampilan yang ciamik ',
              titleStyle: GoogleFonts.montserrat(
                fontSize: sizes.width(context) / 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              subtitle:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
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
