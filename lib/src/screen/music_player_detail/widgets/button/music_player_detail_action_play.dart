import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/config/my_config.dart';
import 'package:kalmics/src/provider/my_provider.dart';

class MusicPlayerDetailActionPlay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final players = watch(globalAudioPlayers).state;
    final _currentSong = watch(currentSongProvider.state);
    return IconButton(
      splashColor: colorPallete.accentColor,
      iconSize: sizes.width(context) / ConstSize.iconActionMusicPlayerDetail,
      color: Colors.white,
      icon: Icon((_currentSong.isPlaying) ? Icons.pause_rounded : Icons.play_arrow_rounded),
      onPressed: () => players.playOrPause(),
    );
  }
}
