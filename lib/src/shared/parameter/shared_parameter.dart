import 'dart:developer';

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
    final BuildContext _globalContext = context.read(globalContext).state!;
    return NotificationSettings(
      customPrevAction: (players) => context.refresh(previousSong),
      customPlayPauseAction: (player) {
        player.playerState.listen((state) {
          switch (state) {
            case PlayerState.play:
              log('state play $state');
              _globalContext.read(currentSongProvider).resumeSong();
              break;
            case PlayerState.pause:
              _globalContext.read(currentSongProvider).pauseSong();
              break;
            default:
              _globalContext.read(currentSongProvider).stopSong();
              break;
          }
        });
        player.playOrPause();
      },
      customNextAction: (player) => context.refresh(nextSong),
      customStopAction: (player) async {
        log('Detail Player : ${await player.audioSessionId.first}\n${(await player.current.first)!.audio.audio.metas}');
        log('state stop');
        _globalContext.read(currentSongProvider).stopSong();
        player.stop();
      },
    );
  }
}
