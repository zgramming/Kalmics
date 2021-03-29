import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/my_config.dart';

class SettingScreen extends StatelessWidget {
  Future<void> openUrl(
    String url, {
    required BuildContext context,
    bool isEmail = false,
  }) async {
    try {
      if (isEmail) {
        final uri = Uri(
          scheme: 'mailto',
          path: url,
          queryParameters: {
            'subject': ConstString.subjectEmail,
            'body': ConstString.bodyEmail,
          },
        );
        launch(uri.toString());
        return;
      }
      if (await canLaunch(url)) {
        await launch(url, universalLinksOnly: true);
      } else {
        throw 'There was a problem to open the url: $url';
      }
    } catch (e) {
      GlobalFunction.showSnackBar(
        context,
        content: Text(e.toString()),
        snackBarType: SnackBarType.error,
      );
    }
  }

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
                    '${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}',
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
                      onTap: () => openUrl(ConstString.urlFacebook, context: context),
                    ),
                    ActionCircleButton(
                      icon: FontAwesomeIcons.github,
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      onTap: () => openUrl(ConstString.urlGithub, context: context),
                    ),
                    ActionCircleButton(
                      icon: FontAwesomeIcons.envelope,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onTap: () => openUrl(
                        ConstString.urlGmail,
                        context: context,
                        isEmail: true,
                      ),
                    ),
                    ActionCircleButton(
                      icon: FontAwesomeIcons.linkedinIn,
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      onTap: () => openUrl(ConstString.urlLinkedIn, context: context),
                    ),
                    ActionCircleButton(
                      icon: FontAwesomeIcons.instagram,
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      onTap: () => openUrl(ConstString.urlInstagram, context: context),
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
