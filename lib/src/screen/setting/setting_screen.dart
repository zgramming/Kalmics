import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../config/my_config.dart';
import '../../shared/my_shared.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: sizes.statusBarHeight(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: ClipOval(
                  child: Image.asset(
                    appConfig.fullPathImageAsset,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.star),
                            ),
                            title: Text(
                              ConstString.giveRating,
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              final inAppReview = InAppReview.instance;
                              await inAppReview.openStoreListing();
                            },
                          ),
                          Divider(
                            color: Colors.white.withOpacity(.5),
                          ),
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.copyright_rounded),
                            ),
                            title: Text(
                              ConstString.copyrightPermission,
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              showDialog(
                                  context: context, builder: (ctx) => SettingDialogIconCopyright());
                            },
                          ),
                          Divider(
                            color: Colors.white.withOpacity(.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Wrap(
                  spacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    ActionCircleButton(
                      icon: FontAwesomeIcons.facebookF,
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      onTap: () =>
                          SharedFunction.openUrl(ConstString.urlFacebook, context: context),
                    ),
                    ActionCircleButton(
                      icon: FontAwesomeIcons.github,
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      onTap: () => SharedFunction.openUrl(ConstString.urlGithub, context: context),
                    ),
                    ActionCircleButton(
                      icon: FontAwesomeIcons.envelope,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () => SharedFunction.openUrl(
                        ConstString.urlGmail,
                        context: context,
                        isEmail: true,
                      ),
                    ),
                    ActionCircleButton(
                      icon: FontAwesomeIcons.linkedinIn,
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      onTap: () =>
                          SharedFunction.openUrl(ConstString.urlLinkedIn, context: context),
                    ),
                    ActionCircleButton(
                      icon: FontAwesomeIcons.instagram,
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      onTap: () =>
                          SharedFunction.openUrl(ConstString.urlInstagram, context: context),
                    ),
                  ],
                ),
                const CopyRightVersion(),
              ],
            ),
          ),
          const SizedBox(height: kToolbarHeight)
        ],
      ),
    );
  }
}

class SettingDialogIconCopyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: sizes.height(context) / 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                '${appConfig.urlImageAsset}/${ConstString.assetIconIcons8}',
              ),
            ),
            Expanded(
              child: Align(
                child: Text.rich(
                  TextSpan(
                    text: 'Icons made by ',
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Icons8 ',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await SharedFunction.openUrl(
                              ConstString.urlIcons8,
                              context: context,
                            );
                          },
                        style: GoogleFonts.openSans().copyWith(color: Colors.blue),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
