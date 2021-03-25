import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import 'package:kalmics/src/network/my_network.dart';
import 'package:kalmics/src/provider/my_provider.dart';

class SharedParameter {
  Metas metas(MusicModel music) {
    return Metas(
      id: music.idMusic,
      album: (music.tag?.album?.isNotEmpty ?? false) ? music.tag?.album : 'Unknown Album',
      artist: (music.tag?.artist?.isNotEmpty ?? false) ? music.tag?.artist : 'Unknown Artist',
      title: (music.title?.isNotEmpty ?? false) ? music.title : 'Unknown Title',
      // image: MetasImage.file(File.fromRawPath(music.artwork ?? base64.decode('')).path),
      onImageLoadFail: MetasImage.asset('${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}'),
    );
  }

  NotificationSettings notificationSettings(
    BuildContext context, {
    required List<MusicModel> musics,
  }) {
    final sharedParameter = SharedParameter();
    return NotificationSettings(
      customPrevAction: (players) {
        final result = context.read(currentSongProvider).previousSong(musics);
        players.open(
          Audio.file(
            result.pathFile ?? '',
            metas: sharedParameter.metas(result),
          ),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            context,
            musics: musics,
          ),
        );
      },
      customPlayPauseAction: (player) => player.playOrPause(),
      customNextAction: (player) {
        final result = context.read(currentSongProvider).nextSong(musics);
        player.open(
          Audio.file(
            result.pathFile ?? '',
            metas: sharedParameter.metas(result),
          ),
          showNotification: true,
          notificationSettings: sharedParameter.notificationSettings(
            context,
            musics: musics,
          ),
        );
      },
      customStopAction: (player) {
        context.read(currentSongProvider).stopSong();
        player.stop();
      },
    );
  }
}
