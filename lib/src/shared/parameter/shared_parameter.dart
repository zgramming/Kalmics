import 'dart:developer';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:path_provider/path_provider.dart';

import '../../network/my_network.dart';
import '../../provider/my_provider.dart';

class SharedParameter {
  Future<Metas> metas(MusicModel music) async {
    MetasImage? metasImage =
        MetasImage.asset('${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}');

    if (music.artwork != null) {
      final docDir = await getApplicationDocumentsDirectory();
      final dir = Directory('${docDir.path}/notification');
      final createDir = await dir.create(recursive: true);
      final path = '${createDir.path}/${music.idMusic}.png';
      final file = File(path);
      await file.writeAsBytes(music.artwork!);
      metasImage = MetasImage.file(path);
    }

    return Metas(
      id: music.idMusic,
      album: (music.tag?.album?.isNotEmpty ?? false) ? music.tag?.album : 'Unknown Album',
      artist: (music.tag?.artist?.isNotEmpty ?? false) ? music.tag?.artist : 'Unknown Artist',
      title: (music.title?.isNotEmpty ?? false) ? music.title : 'Unknown Title',
      image: metasImage,
      onImageLoadFail: metasImage,
    );
  }

  Future<NotificationSettings> notificationSettings(
    BuildContext context, {
    required List<MusicModel> musics,
  }) async {
    final BuildContext _globalContext = context.read(globalContext).state!;
    return NotificationSettings(
      customPrevAction: (players) async => await context.refresh(previousSong),
      customPlayPauseAction: (player) async {
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
        await player.playOrPause();
      },
      customNextAction: (player) async => await context.refresh(nextSong),
      customStopAction: (player) async {
        log('state stop');
        _globalContext.read(currentSongProvider).stopSong();
        await player.stop();
      },
    );
  }
}
