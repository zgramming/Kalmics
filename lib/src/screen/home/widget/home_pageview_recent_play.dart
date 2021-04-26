import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/my_config.dart';
import '../../../provider/my_provider.dart';
import './home_pageview_recent_play_item.dart';

class HomePageViewRecentPlay extends StatefulWidget {
  @override
  HomePageViewRecentPlayState createState() => HomePageViewRecentPlayState();
}

class HomePageViewRecentPlayState extends State<HomePageViewRecentPlay>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizes.height(context) / 2.25,
      child: Consumer(
        builder: (context, watch, child) {
          final _future = watch(initRecentPlayList);
          final _recentsList = watch(recentsPlayList).state;
          return _future.when(
            data: (value) {
              if (_recentsList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Image.asset(
                          '${appConfig.urlImageAsset}/${ConstString.assetIconGummyIpod}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Dengarkan lagu pertamamu !',
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return HomePageViewRecentPlayItem(recentsPlay: _recentsList);
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Text(
                error.toString(),
              ),
            ),
          );
        },
      ),
    );
  }
}
