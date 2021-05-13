import 'dart:async';
import 'dart:developer' as dv;
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
          dv.log(
              'watching changes on storage Android $event\nPath : ${event.path}\nAction : ${event.type}');

          configFlutterLocalNotification
              .showNotificationChangesToSong(
                title: ConstString.watcherAddTitleMessage,
                body: '$basename Detect has added to application',
                context: context,
                pathFile: file.path,
              )
              .then((_) => context.refresh(addMusic(file.path)));
        }

        ///* Detect if file has remove on storage
        if (event.type == ChangeType.REMOVE) {
          dv.log(
              'watching changes on storage Android $event\nPath : ${event.path}\nAction : ${event.type}');

          configFlutterLocalNotification
              .showNotificationChangesToSong(
                title: ConstString.watcherRemoveTitleMessage,
                body: '$basename Detect has Remove from application',
                context: context,
                pathFile: file.path,
              )
              .then((_) => context.refresh(removeMusic(file.path)));
        }

        ///* Detect if file has modify on storage

        if (event.type == ChangeType.MODIFY) {
          dv.log(
              'watching changes on storage Android $event\nPath : ${event.path}\nAction : ${event.type}');
          configFlutterLocalNotification.showNotificationChangesToSong(
            title: ConstString.watcherModifyTitleMessage,
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

    players.playlistAudioFinished.listen((event) {
      final currentSong = context.read(currentSongProvider.state);
      dv.log('CurrentSong ${currentSong.currentIndex}');

      /// Set Flag if user has stop music [index = -1 indicate song has stop]
      /// Prevent apps to play next song
      if (currentSong.currentIndex >= 0) {
        context.refresh(nextSong).catchError((error) {
          GlobalFunction.showSnackBar(
            context,
            content: Text(error.toString()),
            snackBarType: SnackBarType.error,
          );
        });
      }
    });
  }

  static Future<void> minimizeApp() async {
    try {
      await ConstString.androidMinimizeChannel
          .invokeMethod<bool>(ConstString.androidMinimizeFunction);
    } on PlatformException catch (error) {
      dv.log('platformException ${error.code} || ${error.details} || ${error.message}');
    } catch (e) {
      dv.log('catch ${e.toString()} ');
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

  static Future<void> timerPMB(BuildContext ctx) async {
    final context = ctx.read(globalContext).state!;

    if (context.read(globalTimer).state?.isActive ?? false) {
      context.read(globalTimer).state?.cancel();
    }

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

    if (timerPickerDuration == nowDuration || timerPicker == null) {
      if (timerPicker == null) {
        messageSnackbar = ConstString.messageCancelTimer;
        snackbarType = SnackBarType.info;
      }

      if (timerPickerDuration == nowDuration) {
        messageSnackbar = ConstString.messageTimerIsEqualNow;
        snackbarType = SnackBarType.warning;
      }

      GlobalFunction.showSnackBar(
        context,
        content: Text(messageSnackbar),
        snackBarType: snackbarType,
      );
      return;
    }

    if (timerPickerDuration < nowDuration) {
      result = (const Duration(days: 1).inSeconds) - (nowDuration - timerPickerDuration);
      dv.log(
          'Kurang | ${const Duration(days: 1).inSeconds + nowDuration} - $timerPickerDuration = $result');
    }

    if (timerPickerDuration > nowDuration) {
      result = timerPickerDuration - nowDuration;
      dv.log(
          'jalankan timer || $timerPickerDuration - $nowDuration = ${timerPickerDuration - nowDuration}');
    }

    timerGo = Duration(seconds: result);

    messageSnackbar = ConstString.messageTimerGo;
    snackbarType = SnackBarType.success;

    final _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        dv.log('Tick: ${timer.tick}\nTimerGo: ${timerGo.inSeconds}');
        if (timer.tick >= timerGo.inSeconds) {
          ///* Stop Timer
          timer.cancel();

          ///* Reset remaining timer
          context.read(globalRemainingTimer).state = -1;

          ///* Reset Current Song
          context.read(currentSongProvider).stopSong();

          ///* Stop Song
          await context.read(globalAudioPlayers).state.stop();

          ///* Show message if timer is end
          GlobalFunction.showSnackBar(
            context,
            content: const Text(ConstString.messageTimerEnd),
            snackBarType: SnackBarType.info,
          );
        } else {
          context.read(globalRemainingTimer).state = timerGo.inSeconds - timer.tick;
        }
      },
    );

    ///* Initialize Global Timer
    context.read(globalTimer).state = _timer;
  }
}

class TimerCountdown extends StatefulWidget {
  @override
  _TimerCountdownState createState() => _TimerCountdownState();
}

class _TimerCountdownState extends State<TimerCountdown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
