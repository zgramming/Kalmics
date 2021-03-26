import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../config/my_config.dart';
import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';

class MusicPlayerActionMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) async {
        switch (value) {
          case ConstString.syncPMB:
            context.read(isLoading).state = true;
            context
                .refresh(futureShowListMusic)
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

              context.read(globalTimer).state = Timer.periodic(const Duration(seconds: 1), (timer) {
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
              });
            }

            break;
          case ConstString.sortPMB:
            showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return SizedBox(
                  height: sizes.height(context) / 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Consumer(
                            builder: (context, watch, child) {
                              final _settingProvider = watch(settingProvider.state);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  RadioListTile<String>(
                                    value: ConstString.sortChoiceByTitle,
                                    groupValue: _settingProvider.sortChoice,
                                    onChanged: (choice) {
                                      context.read(settingProvider).setSortChoice(choice ?? '');
                                    },
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    title: const Text('Judul'),
                                    secondary: const Icon(Icons.title),
                                  ),
                                  RadioListTile<String>(
                                    value: ConstString.sortChoiceByArtist,
                                    groupValue: _settingProvider.sortChoice,
                                    onChanged: (choice) {
                                      context.read(settingProvider).setSortChoice(choice ?? '');
                                    },
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    title: const Text('Artis'),
                                    secondary: const Icon(Icons.person_search),
                                  ),
                                  RadioListTile<String>(
                                    value: ConstString.sortChoiceByDuration,
                                    groupValue: _settingProvider.sortChoice,
                                    onChanged: (choice) {
                                      context.read(settingProvider).setSortChoice(choice ?? '');
                                    },
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    title: const Text('Durasi'),
                                    secondary: const Icon(Icons.timer),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Consumer(
                        builder: (_, watch, __) {
                          final ascending =
                              watch(styleAscDescButton(ConstString.ascendingValue)).state;
                          final descending =
                              watch(styleAscDescButton(ConstString.descendingValue)).state;

                          return Row(
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ascending,
                                  onPressed: () {
                                    context
                                        .read(settingProvider)
                                        .setSortByType(SortByType.ascending);
                                  },
                                  icon: const Icon(Icons.arrow_upward_rounded),
                                  label: const Text('Ascending'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: descending,
                                  onPressed: () {
                                    context
                                        .read(settingProvider)
                                        .setSortByType(SortByType.descending);
                                  },
                                  label: const Text('Descending'),
                                  icon: const Icon(Icons.arrow_downward_rounded),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                );
              },
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
