import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/my_provider.dart';

class MusicPlayerDetailImage extends StatefulWidget {
  @override
  _MusicPlayerDetailImageState createState() => _MusicPlayerDetailImageState();
}

class _MusicPlayerDetailImageState extends State<MusicPlayerDetailImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500));

    _opacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Consumer(
          builder: (context, watch, child) {
            final _currentSong = watch(currentSongProvider.state);
            final artwork = _currentSong.song.artwork;
            return artwork == null
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
                  );
          },
        ),
      ),
    );
    // return AnimatedOpacity(
    //   duration: const Duration(seconds: 10),
    //   opacity: ,
    //   child: Center(
    //     child: FlutterLogo(
    //       size: 300,
    //     ),
    //   ),
    // );
  }
}
