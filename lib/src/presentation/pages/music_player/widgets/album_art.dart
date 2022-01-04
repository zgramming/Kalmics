import 'package:flutter/material.dart';
import '../../../../utils/constant.dart';

class AlbumArt extends StatelessWidget {
  const AlbumArt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        assetBGPath,
        fit: BoxFit.cover,
      ),
    );
  }
}
