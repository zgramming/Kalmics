import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../provider/my_provider.dart';

class MusicPlayerDetailTitle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _currentSong = watch(currentSongProvider.state);
    final String artist = _currentSong.song.tag?.artist ?? '';
    final String album = _currentSong.song.tag?.album ?? '';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
          const SizedBox(height: 10.0),
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
          const SizedBox(height: 10.0),
          Expanded(
            child: Align(
              child: Wrap(
                spacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  Container(
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
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorPallete.accentColor,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      )),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorPallete.accentColor,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
