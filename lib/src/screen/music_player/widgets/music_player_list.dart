import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/provider/my_provider.dart';

import 'music_player_item.dart';

class MusicPlayerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizes.screenHeightMinusAppBarAndStatusBar(context),
      child: Consumer(
        builder: (context, watch, child) {
          final futureListMusic = watch(futureShowListMusic);
          final musics = watch(musicProvider.state);
          final _currentSongIsPlaying = watch(currentSongProvider.state).song.idMusic.isNotEmpty;

          if (musics.isEmpty) {
            return futureListMusic.when(
              data: (value) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MusicPlayerItem(music: musics),
                      if (_currentSongIsPlaying) const SizedBox(height: 80)
                    ],
                  ),
                );
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text(error.toString()),
                );
              },
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Lagu : ${musics.length} ',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                MusicPlayerItem(music: musics),
                if (_currentSongIsPlaying) const SizedBox(height: 80)
              ],
            ),
          );
        },
      ),
    );
  }
}
