import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

import '../../../provider/my_provider.dart';
import './music_player_detail_screenshot.dart';
import 'music_player_detail_info_total_playing.dart';

class MusicPlayerDetailTitle extends StatefulWidget {
  @override
  _MusicPlayerDetailTitleState createState() => _MusicPlayerDetailTitleState();
}

class _MusicPlayerDetailTitleState extends State<MusicPlayerDetailTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer(
        builder: (context, watch, child) {
          final _currentSong = watch(currentSongProvider.state);
          final String artist = _currentSong.song.tag?.artist ?? '';
          final String album = _currentSong.song.tag?.album ?? '';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _currentSong.song.title ?? 'Unknown Title',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: sizes.width(context) / 20,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                '${artist.isNotEmpty ? artist : 'Unknown Artists'} - ${album.isNotEmpty ? album : 'Unknown Album'}',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w300,
                  fontSize: sizes.width(context) / 35,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Align(
                  child: Wrap(
                    spacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async => Share.shareFiles(
                          [_currentSong.song.pathFile ?? ''],
                          text: _currentSong.song.title,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorPallete.accentColor,
                          ),
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: MusicPlayerDetailInfoTotalPlaying(
                                idMusic: _currentSong.song.idMusic,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorPallete.accentColor,
                          ),
                          child: const Icon(
                            Icons.info_outline_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          builder: (context) => const MusicPlayerDetailScreenshot(),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorPallete.accentColor,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
