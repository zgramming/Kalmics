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
import 'package:url_launcher/url_launcher.dart';
import 'package:watcher/watcher.dart';

import '../../config/my_config.dart';
import '../../network/my_network.dart';
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
              .showNotificationChangesToSong(
                title: 'File Has Added',
                body: '$basename Detect has added to application',
                context: context,
                pathFile: file.path,
              )
              .whenComplete(() => context.refresh(addMusic(file.path)));
        }

        ///* Detect if file has remove on storage
        if (event.type == ChangeType.REMOVE) {
          log('watching changes on storage Android $event\nPath : ${event.path}\nAction : ${event.type}');

          configFlutterLocalNotification
              .showNotificationChangesToSong(
                title: 'File Has Remove',
                body: '$basename Detect has Remove from application',
                context: context,
                pathFile: file.path,
              )
              .then((_) => context.refresh(removeMusic(file.path)));
        }

        ///* Detect if file has modify on storage

        if (event.type == ChangeType.MODIFY) {
          log('watching changes on storage Android $event\nPath : ${event.path}\nAction : ${event.type}');
          configFlutterLocalNotification.showNotificationChangesToSong(
            title: 'File Has Modify',
            body: '$basename Detect has Modify to application',
            context: context,
            pathFile: file.path,
          );
        }
      }
    });
  }

  static void initAudioPlayers(BuildContext context) {
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
            context.refresh(nextSong).catchError((error) {
              GlobalFunction.showSnackBar(
                context,
                content: Text(error.toString()),
                snackBarType: SnackBarType.error,
              );
            });
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

  static Future<void> timerPMB(BuildContext context) async {
    context.read(globalCounterTimer).state = null;

    var messageSnackbar = '';
    var snackbarType = SnackBarType.normal;

    final timerPicker = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    var timerGo = Duration.zero;
    int result = 0;

    final now = DateTime.now();

    final timerPickerDuration = Duration(
      hours: timerPicker?.hour ?? 0,
      minutes: timerPicker?.minute ?? 0,
    ).inSeconds;

    final nowDuration = Duration(hours: now.hour, minutes: now.minute).inSeconds;

    if (timerPicker == null) {
      messageSnackbar = ConstString.messageCancelTimer;
    }

    if (timerPickerDuration == nowDuration) {
      messageSnackbar = ConstString.messageTimerIsEqualNow;
      snackbarType = SnackBarType.warning;
    }

    if (timerPicker != null && timerPickerDuration != nowDuration) {
      if (timerPickerDuration < nowDuration) {
        result = (const Duration(days: 1).inSeconds) - (nowDuration - timerPickerDuration);
        log('Kurang | ${const Duration(days: 1).inSeconds + nowDuration} - $timerPickerDuration = $result');
      }

      if (timerPickerDuration > nowDuration) {
        result = timerPickerDuration - nowDuration;
        log('jalankan timer || $timerPickerDuration - $nowDuration = ${timerPickerDuration - nowDuration}');
      }

      timerGo = Duration(seconds: result);

      messageSnackbar = ConstString.messageTimerGo;
      snackbarType = SnackBarType.success;

      Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          log('Tick: ${timer.tick}\nTimerGo: ${timerGo.inSeconds}');
          if (timer.tick >= timerGo.inSeconds) {
            GlobalFunction.showSnackBar(
              context,
              content: const Text(ConstString.messageTimerEnd),
              snackBarType: SnackBarType.info,
            );
            timer.cancel();
            context
                .read(globalAudioPlayers)
                .state
                .stop()
                .then((_) => context.read(currentSongProvider).stopSong());
            context.read(globalCounterTimer).state = null;
          }
        },
      );

      context.read(globalCounterTimer).state = TweenAnimationBuilder<Duration>(
        tween: Tween(begin: timerGo, end: Duration.zero),
        duration: timerGo,
        onEnd: () => log('Selesai Timer'),
        builder: (context, value, child) {
          final hours = value.inHours;
          var minutes = value.inMinutes;
          var seconds = value.inSeconds % 60;
          Widget result;
          if (hours > 0) {
            minutes = value.inMinutes % 60;
            seconds = value.inSeconds % 60;
            result = Text('$hours:$minutes:$seconds',
                style: const TextStyle(fontSize: 10, color: Colors.white));
          } else {
            result = Text('$minutes:$seconds',
                style: const TextStyle(fontSize: 12, color: Colors.white));
          }
          return result;
        },
      );
    }
    GlobalFunction.showSnackBar(
      context,
      content: Text(messageSnackbar),
      snackBarType: snackbarType,
    );
  }
}
