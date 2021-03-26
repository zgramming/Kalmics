import 'package:flutter/cupertino.dart';
import 'package:global_template/global_template.dart';

class ConstSize {
  ///* Screen : MusicPlayerDetail

  ///* Widget : [music_player_detail_action_next]
  ///* Widget : [music_player_detail_action_play]
  ///* Widget : [music_player_detail_action_previous]
  ///* Widget : [music_player_detail_action_repeat]
  ///* Widget : [music_player_detail_action_shuffle]
  static double iconActionMusicPlayerDetail(BuildContext context) => sizes.width(context) / 12;
  static double radiusIconActionMusicPlayerDetail(BuildContext context) =>
      sizes.width(context) / 15;

  ///* Widget : [music_player_detail_action]
  static const double spacingIconMusicPlayerDetail = 10.0;

  ///* Screen MusicPlayerScreen

  ///* Widget : [music_player_floating_v1]
  static const double iconPauseAndPlayMusicPlayerFloatingV1 = 40.0;
}
