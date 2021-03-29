import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../config/my_config.dart';
import '../../../provider/my_provider.dart';
import './music_player_action_more_sorting.dart';

class MusicPlayerActionMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) async {
        switch (value) {
          case ConstString.syncPMB:
            context.read(isLoading).state = true;
            context
                .refresh(futureShowListMusic(true))
                .whenComplete(() => context.read(isLoading).state = false);
            break;

          case ConstString.timerPMB:
            final timerPicker = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            var timerGo = Duration.zero;
            int result = 0;
            final now = DateTime.now();

            final timerPickerDuration = Duration(
              hours: timerPicker?.hour ?? 0,
              minutes: timerPicker?.minute ?? 0,
            ).inSeconds;

            final nowDuration = Duration(hours: now.hour, minutes: now.minute).inSeconds;

            if (timerPicker != null && timerPickerDuration != nowDuration) {
              if (timerPickerDuration < nowDuration) {
                result = (const Duration(hours: 24).inSeconds - timerPickerDuration) - nowDuration;
                log('Kurang | $nowDuration - ${const Duration(hours: 24).inSeconds - timerPickerDuration} = $result');
              }

              if (timerPickerDuration > nowDuration) {
                result = timerPickerDuration - nowDuration;
                log('jalankan timer || $timerPickerDuration - $nowDuration = ${timerPickerDuration - nowDuration}');
              }
              timerGo = Duration(seconds: result);

              context.read(globalTimer).state = Timer.periodic(
                const Duration(seconds: 1),
                (timer) {
                  log('Tick: ${timer.tick}\nTimerGo: ${timerGo.inSeconds}');
                  if (timer.tick >= timerGo.inSeconds) {
                    GlobalFunction.showSnackBar(
                      context,
                      content: const Text('Timer telah berakhir'),
                      snackBarType: SnackBarType.info,
                    );
                    timer.cancel();
                    context
                        .read(globalAudioPlayers)
                        .state
                        .stop()
                        .then((_) => context.read(currentSongProvider).stopSong());
                  }
                },
              );
            }

            break;

          case ConstString.sortPMB:
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
          value: ConstString.syncPMB,
          child: Row(
            children: const [
              Icon(Icons.sync_alt_rounded, color: Colors.black),
              SizedBox(width: 10),
              Text('Sinkron lagu'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ConstString.sortPMB,
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
