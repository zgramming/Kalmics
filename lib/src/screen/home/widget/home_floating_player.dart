import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../provider/my_provider.dart';
import '../../music_player_detail/music_player_detail_screen.dart';

class HomeFloatingPlayer extends StatelessWidget {
  const HomeFloatingPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _currengSongProvider = watch(currentSongProvider.state);
        final _currentSongIsPlaying = _currengSongProvider.song.idMusic.isNotEmpty;

        if (_currentSongIsPlaying) {
          return Positioned(
            bottom: 10,
            right: 0,
            child: Stack(
              children: [
                Container(
                  height: kToolbarHeight * 1.5,
                  width: sizes.width(context) / 2.75,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.memory(
                      _currengSongProvider.song.artwork ?? base64.decode(''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => MusicPlayerDetailScreen(),
                    );
                  },
                  child: Container(
                    height: kToolbarHeight * 1.5,
                    width: sizes.width(context) / 2.75,
                    padding: const EdgeInsets.all(4.0),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _currengSongProvider.song.title ?? 'Unknown Song',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
