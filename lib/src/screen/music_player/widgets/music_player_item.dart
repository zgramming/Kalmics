import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';

import '../../music_player_detail/music_player_detail_screen.dart';

import './item/music_player_item_image.dart';
import './item/music_player_item_trailing.dart';
import './music_player_error_dialog.dart';

class MusicPlayerItem extends StatefulWidget {
  final List<MusicModel> musics;
  final MusicModel currentSong;

  const MusicPlayerItem({
    required this.musics,
    required this.currentSong,
  });

  @override
  _MusicPlayerItemState createState() => _MusicPlayerItemState();
}

class _MusicPlayerItemState extends State<MusicPlayerItem> {
  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final currentSong = context.read(currentSongProvider.state);
      if (currentSong.currentIndex >= 0 && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.musics.length,
      itemBuilder: (context, index) {
        final result = widget.musics[index];
        final artis = result.tag?.artist;
        final artwork = result.artwork;
        return Column(
          key: result.idMusic == widget.currentSong.idMusic ? key : null,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: result.idMusic == widget.currentSong.idMusic
                  ? colorPallete.monochromaticColor
                  : Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (result.idMusic == widget.currentSong.idMusic) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => MusicPlayerDetailScreen(),
                    );
                    return;
                  }

                  context.refresh(playSong(result)).then(
                    (_) {
                      context.read(searchQuery).state = '';
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => MusicPlayerDetailScreen(),
                      );
                    },
                  ).catchError(
                    (error) {
                      showDialog(
                        context: context,
                        builder: (context) => MusicPlayerErrorDialog(error: error.toString()),
                      );
                    },
                  );
                },
                child: ListTile(
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
                    child: Consumer(
                      builder: (context, watch, child) {
                        final _formatDuration = watch(formatEachDurationSong(result.idMusic)).state;

                        return Text(
                          '$_formatDuration | ${(artis?.isNotEmpty ?? false) ? artis : 'Unknown Artist'}',
                          maxLines: 1,
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  trailing: MusicPlayerItemTrailing(result: result),
                ),
              ),
            ),
            if (widget.musics.length - 1 != index)
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
