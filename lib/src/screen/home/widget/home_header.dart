import 'package:flutter/material.dart';

import './home_header_longest_listen.dart';
import './home_header_total_listen_song_duration.dart';
import './home_header_total_song_played.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 30,
      children: const [
        HomeHeaderLongestListen(),
        HomeHeaderTotalListenSongDuration(),
        HomeHeaderTotalSongPlayed(),
      ],
    );
  }
}
