import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../../config/my_config.dart';
import '../../../../provider/my_provider.dart';

class MusicPlayerDetailActionShuffle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _settingProvider = watch(settingProvider.state);

    return Tooltip(
      message: ConstString.toolTipShuffle,
      child: InkWell(
        onTap: () {
          final currentStatusShuffle = context.read(settingProvider.state).isShuffle;
          final valueShuffle =
              currentStatusShuffle ? ConstString.notUseShuffle : ConstString.useShuffle;
          context.read(settingProvider).setShuffle(value: valueShuffle);
        },
        child: CircleAvatar(
          backgroundColor:
              _settingProvider.isShuffle ? colorPallete.accentColor : Colors.transparent,
          foregroundColor: Colors.white,
          radius: ConstSize.radiusIconActionMusicPlayerDetail(context),
          child: FittedBox(
            child: Icon(
              Icons.shuffle_rounded,
              size: ConstSize.iconActionMusicPlayerDetail(context),
            ),
          ),
        ),
      ),
    );
  }
}
