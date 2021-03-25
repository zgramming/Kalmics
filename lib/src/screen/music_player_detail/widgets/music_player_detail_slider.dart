import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/provider/my_provider.dart';

class MusicPlayerDetailSlider extends StatelessWidget {
  String _totalDurationSong(BuildContext context) {
    final _currentSong = context.read(currentSongProvider.state);
    final _musics = context.read(musicProvider.state);

    var totalDurationInMinute = 0;
    String _totalRemainingSecond = '';
    final totalDuration = _musics[_currentSong.currentIndex].songDuration;
    totalDurationInMinute = totalDuration?.inMinutes ?? 0;
    final totalRemainingSecond = (totalDuration?.inSeconds ?? 0) % 60;
    _totalRemainingSecond =
        (totalRemainingSecond > 9) ? '$totalRemainingSecond' : '0$totalRemainingSecond';

    return '$totalDurationInMinute.$_totalRemainingSecond';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer(
            builder: (context, watch, child) {
              final players = watch(globalAudioPlayers).state;
              return PlayerBuilder.currentPosition(
                player: players,
                builder: (context, position) {
                  final totalDurationInMinute = position.inMinutes;
                  final totalRemainingSecond = (position.inSeconds) % 60;
                  final resultRemainingSecond = (totalRemainingSecond > 9)
                      ? '$totalRemainingSecond'
                      : '0$totalRemainingSecond';
                  final result = '$totalDurationInMinute.$resultRemainingSecond';
                  return Text(
                    result,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w300,
                    ),
                  );
                },
              );
            },
          ),
          Expanded(
            flex: 10,
            child: Consumer(
              builder: (_, watch, __) {
                final players = watch(globalAudioPlayers).state;
                final _currentSong = watch(currentSongProvider.state);
                return Slider.adaptive(
                  value: _currentSong.currentDuration.inSeconds.toDouble(),
                  max: _currentSong.song.songDuration?.inSeconds.toDouble() ?? 0.0,
                  onChangeStart: (value) async {
                    final newDuration = Duration(seconds: value.toInt());
                    await players.seek(newDuration);
                    context.read(currentSongProvider).setDuration(newDuration);
                    log('onChangeStart $value newDuration $newDuration');
                  },
                  onChanged: (value) async {
                    final newDuration = Duration(seconds: value.toInt());
                    await players.seek(newDuration);
                    context.read(currentSongProvider).setDuration(newDuration);
                    log('onChange $value || newDuration $newDuration');
                  },
                  onChangeEnd: (value) async {
                    final newDuration = Duration(seconds: value.toInt());
                    await players.seek(newDuration);
                    context.read(currentSongProvider).setDuration(newDuration);
                    log('onChangeEnd $value || newDuration $newDuration');
                  },
                );
              },
            ),
          ),
          Text(
            _totalDurationSong(context),
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 11.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
