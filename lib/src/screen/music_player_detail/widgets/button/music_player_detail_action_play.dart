import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalmics/src/config/my_config.dart';
import 'package:kalmics/src/provider/my_provider.dart';

class MusicPlayerDetailActionPlay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final players = watch(globalAudioPlayers).state;
    final _currentSong = watch(currentSongProvider.state);
    return InkWell(
      onTap: () => players.playOrPause(),
      child: CircleAvatar(
        foregroundColor: Colors.white,
        radius: ConstSize.radiusIconActionMusicPlayerDetail(context),
        child: FittedBox(
          child: Icon(
            (_currentSong.isPlaying) ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: ConstSize.iconActionMusicPlayerDetail(context),
          ),
        ),
      ),
    );
  }
}
