import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import '../../../provider/my_provider.dart';

class MusicPlayerDetailScreenshot extends StatefulWidget {
  const MusicPlayerDetailScreenshot({
    Key? key,
  }) : super(key: key);

  @override
  _MusicPlayerDetailScreenshotState createState() => _MusicPlayerDetailScreenshotState();
}

class _MusicPlayerDetailScreenshotState extends State<MusicPlayerDetailScreenshot> {
  final GlobalKey _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ProviderListener<StateController<bool>>(
      provider: isLoading,
      onChange: (context, value) {
        if (value.state) {
          GlobalFunction.showDialogLoading(context);
        }
        Navigator.of(context).pop();
      },
      child: SizedBox(
        height: sizes.height(context) / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Consumer(
                builder: (_, watch, __) {
                  final _currentSong = watch(currentSongProvider.state);
                  return RepaintBoundary(
                    key: _globalKey,
                    child: Stack(
                      children: [
                        Image.memory(
                          _currentSong.song.artwork ?? base64.decode(''),
                          fit: BoxFit.cover,
                          height: sizes.height(context),
                          width: sizes.width(context),
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            '${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}',
                            fit: BoxFit.cover,
                            height: sizes.height(context),
                            width: sizes.width(context),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          width: sizes.width(context) / 1.5,
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: colorPallete.accentColor,
                            ),
                            child: Text.rich(
                              TextSpan(
                                text: 'mendengarkan ',
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                children: [
                                  TextSpan(
                                    text: _currentSong.song.title,
                                    style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: CircleAvatar(
                            radius: sizes.width(context) / 30,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _capture,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20.0),
                shape: const RoundedRectangleBorder(),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Bagikan'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _capture() async {
    ui.Image? image;
    bool catched = false;
    final RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

    try {
      context.read(isLoading).state = true;
      image = await boundary.toImage(pixelRatio: 3.0);
      catched = true;
    } catch (e) {
      GlobalFunction.showSnackBar(
        context,
        content: Text(e.toString()),
      );
      context.read(isLoading).state = false;
      Timer(const Duration(milliseconds: 200), () => _capture());
    }

    if (catched) {
      final ByteData byteData = (await image!.toByteData(format: ui.ImageByteFormat.png))!;
      final pngBytes = byteData.buffer.asUint8List();

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/screenshot/test.png';

      final file = File(path);
      if (await file.exists()) {
        await file.delete(recursive: true);
      } else {
        await file.create(recursive: true);
      }

      await file.writeAsBytes(pngBytes).then((_) => context.read(isLoading).state = false);
      final _currentSong = context.read(currentSongProvider.state);
      Share.shareFiles(
        [file.path],
        text: 'Saya sedang mendengarkan ${_currentSong.song.title}',
        subject: '',
      );
    }
  }
}
