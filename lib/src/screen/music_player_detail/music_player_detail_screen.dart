import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/my_provider.dart';

import './widgets/music_player_detail_action.dart';
import './widgets/music_player_detail_image.dart';
import './widgets/music_player_detail_title.dart';

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
                if (_currentSongProvider.song.artwork == null) {
                  return ShowImageAsset(
                    imageUrl: appConfig.fullPathImageAsset,
                    fit: BoxFit.cover,
                  );
                } else {
                  return Image.memory(
                    _currentSongProvider.song.artwork!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        appConfig.fullPathImageAsset,
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.darken,
                      );
                    },
                  );
                }
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Container(
                            decoration: const BoxDecoration(color: Colors.transparent),
                            child: MusicPlayerDetailImage())),
                    Expanded(
                        flex: 2,
                        child: Container(
                            decoration: const BoxDecoration(color: Colors.transparent),
                            child: MusicPlayerDetailTitle())),
                    Expanded(
                        flex: 2,
                        child: Container(
                            decoration: const BoxDecoration(color: Colors.transparent),
                            child: MusicPlayerDetailAction())),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
