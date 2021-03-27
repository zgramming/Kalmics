import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/shared/my_shared.dart';

import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';
import '../../music_player_detail/music_player_detail_screen.dart';

class MusicPlayerItem extends ConsumerWidget {
  final List<MusicModel> musics;

  MusicPlayerItem({
    required this.musics,
  });
  final sharedParameter = SharedParameter();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: musics.length,
      itemBuilder: (context, index) {
        final result = musics[index];
        final artis = result.tag?.artist;
        final artwork = result.artwork;
        final durationInMinute = result.songDuration?.inMinutes;
        final remainingSecond = (result.songDuration?.inSeconds ?? 0) % 60;
        final _remainingSecond = (remainingSecond > 9) ? '$remainingSecond' : '0$remainingSecond';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async {
                final players = context.read(globalAudioPlayers).state;
                context.read(currentSongProvider).playSong(
                      result,
                      context: context,
                      players: players,
                      musics: musics,
                      currentIndex: index,
                    );

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) {
                    return MusicPlayerDetailScreen();
                  },
                );
              },
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image.memory(
                  artwork ?? base64.decode(''),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return ShowImageAsset(
                        imageUrl: '${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}');
                  },
                ),
              ),
              title: Text(
                result.title!,
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
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_outline_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
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
