import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/config/const/const_size.dart';

import '../../../provider/my_provider.dart';
import '../../music_player_detail/music_player_detail_screen.dart';

class FloatingMusicPlayerV1 extends StatelessWidget {
  const FloatingMusicPlayerV1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Consumer(
        builder: (context, watch, child) {
          final players = context.read(globalAudioPlayers).state;

          final _currentSong = watch(currentSongProvider.state);
          final _currentSongIsPlaying = _currentSong.isPlaying;
          final _currentSongIsFloating = _currentSong.isFloating;

          final artwork = _currentSong.song.artwork ?? Uint8List.fromList([]);
          final artist = _currentSong.song.tag?.artist ?? '';
          final album = _currentSong.song.tag?.album ?? '';
          return Visibility(
            visible: _currentSongIsFloating,
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(MusicPlayerDetailScreen.routeNamed),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: sizes.width(context) / 15,
                  vertical: 12,
                ),
                height: 80,
                width: sizes.width(context),
                color: colorPallete.accentColor,
                child: Row(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        radius: sizes.width(context),
                        backgroundImage: MemoryImage(artwork),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentSong.song.tag?.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${artist.isEmpty ? 'Unknown Artist' : artist} - ${(album.isEmpty) ? 'Unknown Album' : album}',
                              maxLines: 1,
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w300,
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: FloatingActionButton(
                          onPressed: () => players.playOrPause(),
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                          child: Icon(
                            _currentSongIsPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: ConstSize.iconPauseAndPlayMusicPlayerFloatingV1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
