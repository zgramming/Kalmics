import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/network/my_network.dart';
import 'package:kalmics/src/provider/my_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SharedParameter {
  Metas metas(MusicModel music) {
    return Metas(
      album: music.tag?.album,
      artist: music.tag?.artist,
      id: music.idMusic,
      title: music.tag?.title,
      // image: MetasImage.file(File.fromRawPath(music.artwork ?? Uint8List.fromList([])).path),
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
      customPlayPauseAction: (player) {
        player.playOrPause();
      },
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
