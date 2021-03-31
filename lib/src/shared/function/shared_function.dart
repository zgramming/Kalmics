import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kalmics/src/network/model/music/music_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watcher/watcher.dart';

import '../../config/my_config.dart';
import '../../provider/my_provider.dart';

class SharedFunction {
  static void initWatcher(BuildContext context) {
    final watcher = DirectoryWatcher(ConstString.internalPathStorageAndroid);
    final configFlutterLocalNotification = ConfigFlutterLocalNotification();
    watcher.events.listen((event) {
      final file = File(event.path);
      final basename = file.path.split('/').last;
      if (basename.endsWith('.mp3')) {
        ///* Detect if file has adding on storage
        if (event.type == ChangeType.ADD) {
          log('watching changes on storage Android $event\nPath : ${event.path}\nAction : ${event.type}');

          configFlutterLocalNotification
              .showPlanNotification(
                title: 'File Has Added',
                body: '$basename Detect has added to application',
              )
              .whenComplete(() => context.refresh(addMusic(file.path)));
        }

        ///* Detect if file has remove on storage
        if (event.type == ChangeType.REMOVE) {
          log('watching changes on storage Android $event\nPath : ${event.path}\nAction : ${event.type}');

          configFlutterLocalNotification
              .showPlanNotification(
                title: 'File Has Remove',
                body: '$basename Detect has Remove from application',
              )
              .then((_) => context.refresh(removeMusic(file.path)));
        }

        ///* Detect if file has modify on storage

        if (event.type == ChangeType.MODIFY) {
          log('watching changes on storage Android $event\nPath : ${event.path}\nAction : ${event.type}');
          configFlutterLocalNotification.showPlanNotification(
            title: 'File Has Modify',
            body: '$basename Detect has Modify to application',
          );
        }
      }
    });
  }

  static void initAudioPlayers(
    BuildContext context, {
    required Timer? timer,
  }) {
    // initialize [global_timer]
    context.read(globalTimer).state = timer;

    final players = context.read(globalAudioPlayers).state;

    players.currentPosition.listen((currentDuration) {
      final musics = context.read(musicProvider.state);

      if (musics.isNotEmpty) {
        final currentIndex = context.read(currentSongProvider.state).currentIndex;
        if (currentIndex >= 0) {
          final music = context.read(musicProvider.state)[currentIndex];
          final totalDuration = music.songDuration.inSeconds;

          context.read(currentSongProvider).setDuration(currentDuration);

          /// Listen to current duration & total duration song
          /// If current duration exceeds the total song duration, Then Play Next Song
          if (currentDuration.inSeconds >= totalDuration) {
            context.refresh(nextSong);
          }
        }
      }
    });
  }

  static Future<void> minimizeApp() async {
    try {
      await ConstString.androidMinimizeChannel
          .invokeMethod<bool>(ConstString.androidMinimizeFunction);
    } on PlatformException catch (error) {
      log('platformException ${error.code} || ${error.details} || ${error.message}');
    } catch (e) {
      log('catch ${e.toString()} ');
    }
  }

  static Future<bool> onBackButtonPressed(BuildContext context) async {
    final isPlaying = context.read(currentSongProvider.state).isPlaying;

    if (!isPlaying) {
      return Future.value(true);
    }
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Tunggu dulu',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        content: Consumer(
          builder: (context, watch, child) {
            final _currentSong = watch(currentSongProvider.state);
            return Text.rich(
              TextSpan(
                text: 'Sepertinya kamu sedang mendengarkan ',
                children: [
                  TextSpan(
                    text: _currentSong.song.title,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              style: GoogleFonts.openSans(fontSize: 11),
            );
          },
        ),
        actions: [
          OutlinedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await minimizeApp();
            },
            style: OutlinedButton.styleFrom(primary: Colors.red),
            child: Text(
              'Keluar Aplikasi',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(primary: colorPallete.accentColor),
            child: Text(
              'Tetap disini',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );

    return Future.value(true);
  }

  static Future<void> takeImage(
    BuildContext context, {
    required MusicModel music,
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.getImage(source: source);
      if (pickedImage != null) {
        context.read(globalFileArtwork).state = File(pickedImage.path);
        context.refresh(editArtworkSong(music));
      }
      Navigator.of(context).pop();
    } catch (e) {
      GlobalFunction.showSnackBar(
        context,
        content: Text(e.toString()),
        snackBarType: SnackBarType.error,
      );
    }
  }

  static Future<void> openUrl(
    String url, {
    required BuildContext context,
    bool isEmail = false,
  }) async {
    try {
      if (isEmail) {
        final uri = Uri(
          scheme: 'mailto',
          path: url,
          queryParameters: {
            'subject': ConstString.subjectEmail,
            'body': ConstString.bodyEmail,
          },
        );
        launch(uri.toString());
        return;
      }
      if (await canLaunch(url)) {
        await launch(url, universalLinksOnly: true);
      } else {
        throw 'There was a problem to open the url: $url';
      }
    } catch (e) {
      GlobalFunction.showSnackBar(
        context,
        content: Text(e.toString()),
        snackBarType: SnackBarType.error,
      );
    }
  }
}
