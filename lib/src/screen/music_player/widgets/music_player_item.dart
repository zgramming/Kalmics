import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/my_config.dart';
import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';
import '../../../shared/my_shared.dart';
import '../../music_player_detail/music_player_detail_screen.dart';
import './music_player_form_edit_song.dart';

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
                context
                    .refresh(playSong(map))
                    .then((_) => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) => MusicPlayerDetailScreen(),
                        ))
                    .catchError((error) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: SizedBox(
                        height: sizes.height(context) / 3,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    child: Image.asset(
                                        '${appConfig.urlImageAsset}/${ConstString.assetIconErrorSongNotFound}'),
                                  ),
                                ),
                                Text(
                                  error.toString(),
                                  style: GoogleFonts.openSans(
                                    color: Colors.red,
                                    fontSize: 11,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(primary: Colors.blue),
                          child: Text('Sinkron ulang',
                              style: GoogleFonts.openSans().copyWith(color: Colors.white)),
                        )
                      ],
                    ),
                  );
                });
              },
              leading: InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (ctx) => Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Wrap(
                      spacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        ActionCircleButton(
                          icon: Icons.camera,
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          onTap: () => SharedFunction.takeImage(
                            context,
                            source: ImageSource.camera,
                            music: result,
                          ),
                        ),
                        ActionCircleButton(
                          icon: Icons.image,
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          onTap: () => SharedFunction.takeImage(context, music: result),
                        ),
                      ],
                    ),
                  ),
                ),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: artwork == null
                      ? ShowImageAsset(
                          imageUrl: appConfig.fullPathImageAsset,
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          artwork,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return ShowImageAsset(
                              imageUrl: appConfig.fullPathImageAsset,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
              ),
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
              trailing: Wrap(
                children: [
                  PopupMenuButton(
                    onSelected: (value) async {
                      switch (value) {
                        case ConstString.editSongPMB:
                          showDialog(
                            context: context,
                            builder: (context) => FormEditSong(music: result),
                          );
                          break;
                        default:
                          GlobalFunction.showSnackBar(
                            context,
                            content: const Text(ConstString.menuPopUpButtonNotValid),
                            snackBarType: SnackBarType.error,
                          );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: ConstString.editSongPMB,
                        child: Row(
                          children: const [
                            Icon(Icons.edit_outlined, color: Colors.black),
                            SizedBox(width: 10),
                            Text('Ubah'),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),
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
