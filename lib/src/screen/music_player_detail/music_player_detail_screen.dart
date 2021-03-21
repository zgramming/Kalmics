import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/provider/music/current_song_provider.dart';

import 'widgets/music_player_detail_action.dart';
import 'widgets/music_player_detail_image.dart';
import 'widgets/music_player_detail_title.dart';

class MusicPlayerDetailScreen extends StatelessWidget {
  static const routeNamed = '/detail-music-player-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Consumer(
              builder: (context, watch, child) {
                final _currentSongProvider = watch(currentSongProvider.state);
                return Image.memory(
                  _currentSongProvider.song.artwork ?? Uint8List.fromList([]),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      '${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}',
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.darken,
                    );
                  },
                );
              },
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              color: Colors.grey.shade400.withOpacity(.2),
            ),
          ),
          Consumer(
            builder: (context, watch, child) {
              return SizedBox.expand(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    top: sizes.statusBarHeight(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 4, child: MusicPlayerDetailImage()),
                      Expanded(flex: 2, child: MusicPlayerDetailTitle()),
                      Expanded(flex: 2, child: MusicPlayerDetailAction()),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
