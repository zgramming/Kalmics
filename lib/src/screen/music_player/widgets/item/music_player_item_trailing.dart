import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/config/my_config.dart';

import '../../../../network/my_network.dart';
import '../music_player_form_edit_song.dart';

class MusicPlayerItemTrailing extends StatelessWidget {
  const MusicPlayerItemTrailing({
    Key? key,
    required this.result,
  }) : super(key: key);

  final MusicModel result;

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
    );
  }
}
