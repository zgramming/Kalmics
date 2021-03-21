import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/shared/my_shared.dart';

import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';
import '../../music_player_detail/music_player_detail_screen.dart';

class MusicPlayerItem extends StatefulWidget {
  final List<MusicModel> music;

  const MusicPlayerItem({
    Key? key,
    required this.music,
  }) : super(key: key);

  @override
  _MusicPlayerItemState createState() => _MusicPlayerItemState();
}

class _MusicPlayerItemState extends State<MusicPlayerItem> {
  final SharedParameter sharedParameter = SharedParameter();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.music.length,
      itemBuilder: (context, index) {
        final result = widget.music[index];
        final artis = result.tag?.artist;
        final artwork = result.artwork;
        final durationInMinute = result.totalDuration?.inMinutes;
        final remainingSecond = (result.totalDuration?.inSeconds ?? 0) % 60;
        final _remainingSecond = (remainingSecond > 9) ? '$remainingSecond' : '0$remainingSecond';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                context.read(currentSongProvider).playSong(result, index: index);

                final players = context.read(globalAudioPlayers).state;
                players.open(
                  Audio.file(
                    result.pathFile ?? '',
                    metas: sharedParameter.metas(result),
                  ),
                  showNotification: true,
                  notificationSettings: sharedParameter.notificationSettings(
                    context,
                    musics: widget.music,
                  ),
                );
                Navigator.of(context).pushNamed(MusicPlayerDetailScreen.routeNamed);
              },
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: colorPallete.accentColor,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: AssetImage('${appConfig.urlImageAsset}/Kalmics.png'),
                  ),
                ),
                child: (artwork == null) ? const Text('Unknown Artwork') : Image.memory(artwork),
              ),
              title: Text(
                result.tag?.title ?? '',
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
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
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
