import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/my_provider.dart';

import './widget/home_pageview_recent_play.dart';
import 'widget/home_floating_player.dart';
import 'widget/home_line_chart.dart';
import 'widget/home_most_playing_song.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox.expand(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: sizes.statusBarHeight(context) * 2,
                left: 12,
                right: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeLineChart(),
                  Divider(color: Colors.white.withOpacity(.5)),
                  const SizedBox(height: 20),
                  const HomeMostPlayingSong(),
                  Divider(color: Colors.white.withOpacity(.5)),
                  const SizedBox(height: 20),
                  HomePageViewRecentPlay(),
                  const SizedBox(height: 20),
                  Consumer(
                    builder: (_, watch, __) {
                      final _currengSongProvider = watch(currentSongProvider.state);
                      final _currentSongIsFloating = _currengSongProvider.isFloating;
                      if (_currentSongIsFloating) {
                        return SizedBox(height: sizes.height(context) / 8);
                      }
                      return SizedBox(height: sizes.height(context) / 20);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const HomeFloatingPlayer()
      ],
    );
  }
}
