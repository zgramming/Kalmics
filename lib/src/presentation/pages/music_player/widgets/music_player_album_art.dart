import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/fonts.dart';

class MusicPlayerAlbumArt extends StatelessWidget {
  const MusicPlayerAlbumArt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: sizes.width(context) / 2,
            height: sizes.width(context) / 2,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primary,
            ),
            child: ClipOval(
              child: Image.asset(
                assetBGPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Boku no Sensou',
          style: firaSansWhite.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          'Shinsei Kamattechan',
          style: amikoWhite.copyWith(
            fontSize: 12.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
