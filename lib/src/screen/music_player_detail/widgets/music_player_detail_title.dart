import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../provider/my_provider.dart';

class MusicPlayerDetailTitle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _currentSong = watch(currentSongProvider.state);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _currentSong.song.tag?.title ?? 'Unknown Title',
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
            '${_currentSong.song.tag?.artist} - ${_currentSong.song.tag?.album}',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w300,
              fontSize: sizes.width(context) / 35,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
