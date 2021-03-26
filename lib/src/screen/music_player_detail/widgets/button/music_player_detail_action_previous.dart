import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/my_config.dart';
import '../../../../provider/my_provider.dart';
import '../../../../shared/my_shared.dart';

class MusicPlayerDetailActionPrevious extends ConsumerWidget {
  final SharedParameter sharedParameter = SharedParameter();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final players = watch(globalAudioPlayers).state;
    final _musics = watch(musicProvider.state);
    return InkWell(
      onTap: () {
        final _globalAnimation = context.read(globalSizeAnimationController).state;
        _globalAnimation?.reset();

        Future.delayed(const Duration(milliseconds: 200), () {
          final result = context.read(currentSongProvider).previousSong(_musics);
          players.open(
            Audio.file(
              result.pathFile ?? '',
              metas: sharedParameter.metas(result),
            ),
            showNotification: true,
            notificationSettings: sharedParameter.notificationSettings(
              context,
              musics: _musics,
            ),
          );
          _globalAnimation?.forward();
        });
      },
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        radius: ConstSize.radiusIconActionMusicPlayerDetail(context),
        child: FittedBox(
          child: Icon(
            Icons.skip_previous_rounded,
            size: ConstSize.iconActionMusicPlayerDetail(context),
          ),
        ),
      ),
    );
  }
}
