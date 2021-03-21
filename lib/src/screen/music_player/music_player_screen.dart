import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kalmics/src/provider/my_provider.dart';

import 'widgets/music_player_floating_v1.dart';
import 'widgets/music_player_list.dart';

class MusicPlayerScreen extends StatefulWidget {
  static const routeNamed = '/music-player-screen';

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Kalmics',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.stop_rounded),
              onPressed: () {
                final players = context.read(globalAudioPlayers).state;
                final _currentSongProvider = context.read(currentSongProvider);
                _currentSongProvider.stopSong();
                players.stop();
              }),
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(icon: const Icon(Icons.sort_rounded), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          MusicPlayerList(),
          const FloatingMusicPlayerV1(),
        ],
      ),
    );
  }
}
