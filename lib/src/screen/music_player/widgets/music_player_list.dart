import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../provider/my_provider.dart';

import './music_player_item.dart';

class MusicPlayerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizes.height(context),
      child: Padding(
        padding: EdgeInsets.only(top: kToolbarHeight + sizes.statusBarHeight(context)),
        child: Consumer(
          builder: (context, watch, child) {
            final _currentSongProvider = watch(currentSongProvider.state);
            final _totalMusic = watch(totalMusic).state;
            final _filteredMusic = watch(filteredMusic).state;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Lagu : $_totalMusic ',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  MusicPlayerItem(musics: _filteredMusic),
                  if (_currentSongProvider.isFloating) const SizedBox(height: kToolbarHeight * 1.75)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
