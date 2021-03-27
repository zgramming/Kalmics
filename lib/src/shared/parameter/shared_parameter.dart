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
    return NotificationSettings(
      customPrevAction: (players) {
        context.read(currentSongProvider).previousSong(
              musics,
              context: context,
              players: players,
            );
      },
      customPlayPauseAction: (player) {
        player.playOrPause();
        player.playerState.listen((state) {
          switch (state) {
            case PlayerState.play:
              context.read(currentSongProvider).resumeSong();
              break;
            case PlayerState.pause:
              context.read(currentSongProvider).pauseSong();
              break;
            default:
              context.read(currentSongProvider).stopSong();
              break;
          }
        });
      },
      customNextAction: (player) {
        final currentLoop = context.read(settingProvider.state).loopMode;
        context.read(currentSongProvider).nextSong(
              musics,
              loopModeSetting: currentLoop,
              context: context,
              players: player,
            );
      },
      customStopAction: (player) {
        context.read(currentSongProvider).stopSong();
        player.stop();
      },
    );
  }
}
