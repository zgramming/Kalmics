import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';

import '../../music_player_detail/music_player_detail_screen.dart';

import './item/music_player_item_image.dart';
import './item/music_player_item_trailing.dart';
import './music_player_error_dialog.dart';

class MusicPlayerItem extends StatelessWidget {
  final List<MusicModel> musics;

  const MusicPlayerItem({
    required this.musics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: musics.length,
      itemBuilder: (context, index) {
        final result = musics[index];
        final artis = result.tag?.artist;
        final artwork = result.artwork;
        final durationInMinute = result.songDuration.inMinutes;
        final remainingSecond = (result.songDuration.inSeconds) % 60;
        final _remainingSecond = (remainingSecond > 9) ? '$remainingSecond' : '0$remainingSecond';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async {
                final map = {'music': result, 'index': index};
                context.refresh(playSong(map)).then(
                  (_) {
                    context.read(searchQuery).state = '';
                    return showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => MusicPlayerDetailScreen(),
                    );
                  },
                ).catchError(
                  (String error) => showDialog(
                    context: context,
                    builder: (context) => MusicPlayerErrorDialog(error: error),
                  ),
                );
              },
              leading: MusicPlayerItemImage(result: result, artwork: artwork),
              title: Text(
                result.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '$durationInMinute.$_remainingSecond | ${(artis?.isNotEmpty ?? false) ? artis : 'Unknown Artist'}',
                  maxLines: 1,
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 10,
                  ),
                ),
              ),
              trailing: MusicPlayerItemTrailing(result: result),
            ),
            if (musics.length - 1 != index)
              Divider(
                color: Colors.white.withOpacity(.5),
                endIndent: 15,
                indent: 15,
              ),
          ],
        );
      },
    );
  }
}
