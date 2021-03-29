import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/my_config.dart';
import '../../../../provider/my_provider.dart';
import '../../../../shared/my_shared.dart';

class MusicPlayerDetailActionPrevious extends StatelessWidget {
  final SharedParameter sharedParameter = SharedParameter();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final _globalAnimation = context.read(globalSizeAnimationController).state;
        _globalAnimation?.reset();

        Future.delayed(const Duration(milliseconds: 200), () {
          context.refresh(previousSong);
          _globalAnimation?.forward();
        });
      },
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        radius: ConstSize.radiusIconActionMusicPlayerDetail(context),
        child: FittedBox(
          child: Icon(
            Icons.skip_previous_rounded,
            size: ConstSize.iconActionMusicPlayerDetail(context),
          ),
        ),
      ),
    );
  }
}
