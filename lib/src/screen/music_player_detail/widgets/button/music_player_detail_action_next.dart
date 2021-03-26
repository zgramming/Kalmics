import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kalmics/src/config/my_config.dart';
import 'package:kalmics/src/provider/my_provider.dart';
import 'package:kalmics/src/shared/my_shared.dart';

class MusicPlayerDetailActionNext extends ConsumerWidget {
  final SharedParameter sharedParameter = SharedParameter();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final players = watch(globalAudioPlayers).state;
    final _musics = watch(musicProvider.state);
    return InkWell(
      onTap: () {
        final _globalAnimation = context.read(globalSizeAnimationController).state;
        _globalAnimation?.reset();
        Future.delayed(const Duration(milliseconds: 200), () {
          final currentLoop = context.read(settingProvider.state).loopMode;
          context.read(currentSongProvider).nextSong(
                _musics,
                loopModeSetting: currentLoop,
                context: context,
                players: players,
              );

          _globalAnimation?.forward();
        });
      },
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        radius: ConstSize.radiusIconActionMusicPlayerDetail(context),
        child: FittedBox(
          child: Icon(
            Icons.skip_next_rounded,
            size: ConstSize.iconActionMusicPlayerDetail(context),
          ),
        ),
      ),
    );
  }
}
