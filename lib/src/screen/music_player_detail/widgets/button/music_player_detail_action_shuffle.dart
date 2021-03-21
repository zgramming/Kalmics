import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/config/my_config.dart';

class MusicPlayerDetailActionShuffle extends StatelessWidget {
  const MusicPlayerDetailActionShuffle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shuffle_rounded),
      iconSize: sizes.width(context) / ConstSize.iconActionMusicPlayerDetail,
      color: Colors.white,
      onPressed: () {},
    );
  }
}
