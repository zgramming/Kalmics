import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/fonts.dart';
import '../../../utils/navigation.dart';
import '../music_player/music_player_page.dart';
import 'widgets/mbs_more_option.dart';

class HomePage extends StatelessWidget {
  static const routeNamed = '/home-page';
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListView.separated(
            padding: const EdgeInsets.all(24.0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 100,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) => InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () async => globalNavigation.pushNamed(
                routeName: MusicPlayerPage.routeNamed,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: monochromatic),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          assetLogoPath,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Boku no Sensou',
                                style: firaSansWhite.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Shinsei Kamattechan',
                                style: amikoWhite.copyWith(
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    '4 Menit 36 Detik',
                                    style: amikoWhite.copyWith(
                                      fontSize: 9.0,
                                      color: darkGrey400,
                                    ),
                                  ),
                                  if (index == 3)
                                    const Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.white,
                                      size: 15.0,
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) => const MBSMoreOptionSong(),
                          );
                        },
                        icon: const Icon(
                          FeatherIcons.moreVertical,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
