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
      bottom: 10,
      right: 10,
      left: 10,
      child: Consumer(
        builder: (context, watch, child) {
          final _currentSong = watch(currentSongProvider.state);
          final _currentSongIsPlaying = _currentSong.isPlaying;
          final _currentSongIsFloating = _currentSong.isFloating;

          if (_currentSong.song.idMusic.isEmpty) {
            return const SizedBox();
          }
          final _music = watch(musicById(_currentSong.song.idMusic)).state;
          final title = _music.title ?? '';
          final artwork = _music.artwork;
          final artist = _music.tag?.artist ?? '';
          final album = _music.tag?.album ?? '';
          return Visibility(
            visible: _currentSongIsFloating,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) {
                    return MusicPlayerDetailScreen();
                  },
                );
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: sizes.width(context) / 15,
                  vertical: 12,
                ),
                height: kToolbarHeight * 1.5,
                width: sizes.width(context),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(60),
                  color: colorPallete.accentColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: artwork == null
                            ? Image.asset(
                                '${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}',
                                fit: BoxFit.cover,
                              )
                            : Image.memory(
                                artwork,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      '${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}',
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
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
                              title,
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
                          onPressed: () {
                            context.read(globalAudioPlayers).state.playOrPause();
                            if (_currentSong.isPlaying) {
                              context.read(currentSongProvider).pauseSong();
                              return;
                            }
                            context.read(currentSongProvider).resumeSong();
                          },
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
