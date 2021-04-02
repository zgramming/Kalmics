import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../provider/my_provider.dart';

class MusicPlayerDetailSlider extends StatelessWidget {
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
                  max: _currentSong.song.songDuration.inSeconds.toDouble(),
                  onChangeStart: (value) async {
                    final newDuration = Duration(seconds: value.toInt());
                    await players.seek(newDuration);
                    context.read(currentSongProvider).setDuration(newDuration);
                  },
                  onChanged: (value) async {
                    final newDuration = Duration(seconds: value.toInt());
                    await players.seek(newDuration);
                    context.read(currentSongProvider).setDuration(newDuration);
                  },
                  onChangeEnd: (value) async {
                    final newDuration = Duration(seconds: value.toInt());
                    await players.seek(newDuration);
                    context.read(currentSongProvider).setDuration(newDuration);
                  },
                );
              },
            ),
          ),
          Consumer(
            builder: (context, watch, child) {
              final _totalDurationFormat = watch(totalDurationFormat).state;
              return Text(
                _totalDurationFormat,
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w300,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
