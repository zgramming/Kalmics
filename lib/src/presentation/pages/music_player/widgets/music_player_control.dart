import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MusicPlayerControl extends StatelessWidget {
  const MusicPlayerControl({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.shuffle, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.skipBack, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.pause, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.skipForward, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.repeat, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
