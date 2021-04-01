import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/config/my_config.dart';
import 'package:kalmics/src/provider/my_provider.dart';
import 'package:kalmics/src/shared/my_shared.dart';

class MusicPlayerDetailActionNext extends StatelessWidget {
  final SharedParameter sharedParameter = SharedParameter();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final _globalAnimation = context.read(globalSizeAnimationController).state;
        _globalAnimation?.reset();
        Future.delayed(const Duration(milliseconds: 200), () {
          context
              .refresh(nextSong)
              .then((value) => _globalAnimation?.forward())
              .catchError((error) {
            GlobalFunction.showSnackBar(
              context,
              content: Text(error.toString()),
              snackBarType: SnackBarType.error,
            );
          });
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
