import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/music_player_detail_action.dart';
import 'widgets/music_player_detail_image.dart';
import 'widgets/music_player_detail_title.dart';

class MusicPlayerDetailScreen extends StatelessWidget {
  static const routeNamed = '/detail-music-player-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(icon: const Icon(Icons.favorite_rounded), onPressed: () {}),
          const SizedBox(width: 8.0),
        ],
      ),
      body: Consumer(
        builder: (context, watch, child) {
          return SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
    );
  }
}
