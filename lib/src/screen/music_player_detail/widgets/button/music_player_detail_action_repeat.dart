import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/config/my_config.dart';
import 'package:kalmics/src/provider/my_provider.dart';

class MusicPlayerDetailActionRepeat extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final players = watch(globalAudioPlayers).state;
    return IconButton(
      icon: const Icon(Icons.repeat),
      iconSize: sizes.width(context) / ConstSize.iconActionMusicPlayerDetail,
      color: Colors.white,
      onPressed: () {
        players.setLoopMode(LoopMode.playlist);
      },
    );
  }
}
