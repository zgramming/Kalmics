import 'dart:ui';

import 'package:flutter/material.dart';

class AlbumArtGlassEffect extends StatelessWidget {
  const AlbumArtGlassEffect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15.0,
          sigmaY: 15.0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
        ),
      ),
    );
  }
}
