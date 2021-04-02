import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/my_provider.dart';

class MusicPlayerDetailImage extends StatefulWidget {
  @override
  _MusicPlayerDetailImageState createState() => _MusicPlayerDetailImageState();
}

class _MusicPlayerDetailImageState extends State<MusicPlayerDetailImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;
  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      context.read(globalSizeAnimationController).state = _sizeController;
    });
    _sizeController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _sizeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _sizeController, curve: Curves.fastOutSlowIn));
    _sizeController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _currentSong = watch(currentSongProvider.state);
        final artwork = _currentSong.song.artwork;
        return SizeTransition(
          sizeFactor: _sizeAnimation,
          axis: Axis.horizontal,
          child: artwork == null
              ? Image.asset(
                  appConfig.fullPathImageAsset,
                  fit: BoxFit.cover,
                  width: sizes.width(context),
                )
              : Image.memory(
                  artwork,
                  fit: BoxFit.cover,
                  height: sizes.height(context),
                  width: sizes.width(context),
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      appConfig.fullPathImageAsset,
                      fit: BoxFit.cover,
                      width: sizes.width(context),
                    );
                  },
                ),
        );
      },
    );
  }
}
