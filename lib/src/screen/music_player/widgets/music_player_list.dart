import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/my_provider.dart';

import './music_player_item.dart';

class MusicPlayerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizes.height(context),
      child: Consumer(
        builder: (context, watch, child) {
          final _currentSongProvider = watch(currentSongProvider.state);
          final _filteredMusic = watch(filteredMusic).state;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MusicPlayerItem(
                  musics: _filteredMusic,
                  currentSong: _currentSongProvider.song,
                ),
                if (_currentSongProvider.isFloating) const SizedBox(height: kToolbarHeight * 1.75)
              ],
            ),
          );
        },
      ),
    );
  }
}
