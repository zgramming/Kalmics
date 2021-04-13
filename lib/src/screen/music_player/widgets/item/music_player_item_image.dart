import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../network/my_network.dart';
import '../../../../shared/my_shared.dart';

class MusicPlayerItemImage extends StatelessWidget {
  const MusicPlayerItemImage({
    Key? key,
    required this.result,
    required this.artwork,
  }) : super(key: key);

  final MusicModel result;
  final Uint8List? artwork;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            spacing: 20,
            alignment: WrapAlignment.center,
            children: [
              ActionCircleButton(
                icon: Icons.camera,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                onTap: () => SharedFunction.takeImage(
                  context,
                  source: ImageSource.camera,
                  music: result,
                ),
              ),
              ActionCircleButton(
                icon: Icons.image,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                onTap: () => SharedFunction.takeImage(context, music: result),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: artwork == null
            ? ShowImageAsset(
                imageUrl: appConfig.fullPathImageAsset,
                fit: BoxFit.cover,
              )
            : Image.memory(
                artwork!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return ShowImageAsset(
                    imageUrl: appConfig.fullPathImageAsset,
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }
}
