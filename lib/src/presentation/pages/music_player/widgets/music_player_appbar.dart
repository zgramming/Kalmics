import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/fonts.dart';

class MusicPlayerAppBar extends StatelessWidget {
  const MusicPlayerAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: monochromatic.withOpacity(.25),
      title: Text(
        'Now Playing',
        style: firaSansWhite,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            FeatherIcons.heart,
          ),
        )
      ],
    );
  }
}
