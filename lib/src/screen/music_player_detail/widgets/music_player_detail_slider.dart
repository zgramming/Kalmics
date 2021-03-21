import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/provider/my_provider.dart';

class MusicPlayerDetailSlider extends ConsumerWidget {
  String _durationSong(
    BuildContext context, {
    bool isShowTotal = true,
  }) {
    final _currentSong = context.read(currentSongProvider.state);
    final _musics = context.read(musicProvider.state);

    var totalDurationInMinute = 0;
    String _totalRemainingSecond = '';
    if (isShowTotal) {
      final totalDuration = _musics[_currentSong.currentIndex].songDuration;
      totalDurationInMinute = totalDuration?.inMinutes ?? 0;
      final totalRemainingSecond = (totalDuration?.inSeconds ?? 0) % 60;
      _totalRemainingSecond =
          (totalRemainingSecond > 9) ? '$totalRemainingSecond' : '0$totalRemainingSecond';
    } else {
      totalDurationInMinute = _currentSong.currentDuration.inMinutes;
      final totalRemainingSecond = (_currentSong.currentDuration.inSeconds) % 60;
      _totalRemainingSecond =
          (totalRemainingSecond > 9) ? '$totalRemainingSecond' : '0$totalRemainingSecond';
    }
    return '$totalDurationInMinute.$_totalRemainingSecond';
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final players = watch(globalAudioPlayers).state;
    final _currentSong = watch(currentSongProvider.state);

    return Container(
      padding: const EdgeInsets.symmetric(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _durationSong(context, isShowTotal: false),
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 11.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          Expanded(
            flex: 10,
            child: Slider.adaptive(
              value: _currentSong.currentDuration.inSeconds.toDouble(),
              max: _currentSong.song.songDuration?.inSeconds.toDouble() ?? 0.0,
              onChangeStart: (value) {
                final newDuration = Duration(seconds: value.toInt());
                context.read(currentSongProvider).setDuration(newDuration);
                players.seek(newDuration);
                log('onChangeStart $value newDuration $newDuration');
              },
              onChanged: (value) {
                final newDuration = Duration(seconds: value.toInt());
                context.read(currentSongProvider).setDuration(newDuration);
                players.seek(newDuration);
                log('onChange $value || newDuration $newDuration');
              },
              onChangeEnd: (value) {
                final newDuration = Duration(seconds: value.toInt());
                players.seek(newDuration);
                context.read(currentSongProvider).setDuration(newDuration);
                log('onChangeEnd $value || newDuration $newDuration');
              },
            ),
          ),
          Text(
            _durationSong(context),
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
