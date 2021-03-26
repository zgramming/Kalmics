import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/my_provider.dart';

class MusicPlayerDetailActionRepeat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final currentLoopMode = context.read(settingProvider.state).loopMode;
        context.read(settingProvider).setLoopMode(currentLoopMode);
      },
      child: Consumer(
        builder: (context, watch, child) {
          final icon = watch(iconLoopMode(context)).state;
          return icon;
        },
      ),
    );
  }
}
