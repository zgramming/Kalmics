import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/my_config.dart';
import '../../../provider/my_provider.dart';
import '../../../shared/my_shared.dart';

import './music_player_action_more_sorting.dart';

class MusicPlayerActionMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) async {
        switch (value) {
          case ConstString.syncSongPMB:
            context.read(isLoading).state = true;
            context
                .refresh(initializeMusicFromStorage)
                .whenComplete(() => context.read(isLoading).state = false);
            break;

          case ConstString.timerPMB:
            SharedFunction.timerPMB(context);
            break;

          case ConstString.sortSongPMB:
            showModalBottomSheet(
              context: context,
              builder: (ctx) => const MusicPlayerActionMoreSorting(),
            );
            break;
          default:
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ConstString.syncSongPMB,
          child: Row(
            children: const [
              Icon(Icons.sync_alt_rounded, color: Colors.black),
              SizedBox(width: 10),
              Text('Sinkron lagu'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ConstString.sortSongPMB,
          child: Row(
            children: const [
              Icon(Icons.sort, color: Colors.black),
              SizedBox(width: 10),
              Text('Urut berdasarkan'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ConstString.timerPMB,
          child: Row(
            children: const [
              Icon(Icons.timer_rounded, color: Colors.black),
              SizedBox(width: 10),
              Text('Timer'),
            ],
          ),
        ),
      ],
    );
  }
}
