import 'package:flutter/material.dart';

import '../../../config/my_config.dart';
import './button/music_player_detail_action_next.dart';
import './button/music_player_detail_action_play.dart';
import './button/music_player_detail_action_previous.dart';
import './button/music_player_detail_action_repeat.dart';
import './button/music_player_detail_action_shuffle.dart';
import './music_player_detail_slider.dart';

class MusicPlayerDetailAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MusicPlayerDetailSlider(),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: ConstSize.spacingIconMusicPlayerDetail,
            children: [
              MusicPlayerDetailActionShuffle(),
              MusicPlayerDetailActionPrevious(),
              MusicPlayerDetailActionPlay(),
              MusicPlayerDetailActionNext(),
              MusicPlayerDetailActionRepeat(),
            ],
          )
        ],
      ),
    );
  }
}
