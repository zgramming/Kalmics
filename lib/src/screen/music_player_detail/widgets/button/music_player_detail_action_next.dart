import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/config/my_config.dart';
import 'package:kalmics/src/provider/my_provider.dart';
import 'package:kalmics/src/shared/my_shared.dart';

class MusicPlayerDetailActionNext extends ConsumerWidget {
  final SharedParameter sharedParameter = SharedParameter();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final players = watch(globalAudioPlayers).state;
    final _musics = watch(musicProvider.state);
    return IconButton(
      iconSize: sizes.width(context) / ConstSize.iconActionMusicPlayerDetail,
      color: Colors.white,
      icon: const Icon(Icons.skip_next_rounded),
      onPressed: () {
        final result = context.read(currentSongProvider).nextSong(_musics);
        players.open(
          Audio.file(result.pathFile ?? '', metas: sharedParameter.metas(result)),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            context,
            musics: _musics,
          ),
        );
      },
    );
  }
}
