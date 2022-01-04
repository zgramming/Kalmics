import 'package:flutter/material.dart';
import 'widgets/album_art.dart';
import 'widgets/album_art_glass_effect.dart';
import 'widgets/music_player_album_art.dart';
import 'widgets/music_player_appbar.dart';
import 'widgets/music_player_control.dart';
import 'widgets/music_player_sharing.dart';
import 'widgets/music_player_slider.dart';

class MusicPlayerPage extends StatelessWidget {
  static const routeNamed = '/music-player-page';
  const MusicPlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: const [
          AlbumArt(),
          AlbumArtGlassEffect(),
          MusicPlayerContent(),
        ],
      ),
    );
  }
}

class MusicPlayerContent extends StatelessWidget {
  const MusicPlayerContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MusicPlayerAppBar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  flex: 7,
                  child: MusicPlayerAlbumArt(),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(height: 20),
                      MusicPlayerSharing(),
                      SizedBox(height: 10),
                      MusicPlayerSlider(),
                      SizedBox(height: 10),
                      MusicPlayerControl(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
