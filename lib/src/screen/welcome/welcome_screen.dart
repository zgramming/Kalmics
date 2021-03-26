import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watcher/watcher.dart';

import '../../config/my_config.dart';
import '../../provider/my_provider.dart';
import '../../shared/my_shared.dart';
import '../home/home_screen.dart';
import '../music_player/music_player_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = '/welcome-screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final sharedParameter = SharedParameter();
  final configFlutterLocalNotification = ConfigFlutterLocalNotification();
  int _selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    SettingScreen(),
  ];

  Timer? timer;

  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      // initialize [global_timer]
      context.read(globalTimer).state = timer;

      final players = context.read(globalAudioPlayers).state;

      players.playerState.listen((event) {
        log('4.) playerStateListen $event');
        final _currentSong = context.read(currentSongProvider.state);
        switch (event) {
          case PlayerState.play:
            context.read(currentSongProvider).playSong(_currentSong.song);
            break;
          case PlayerState.pause:
            context.read(currentSongProvider).pauseSong();
            break;
          default:
            context.read(currentSongProvider).stopSong();
            break;
        }
      });

      players.currentPosition.listen((currentDuration) {
        final musics = context.read(musicProvider.state);

        if (musics.isNotEmpty) {
          context.read(currentSongProvider).setDuration(currentDuration);
          final currentIndex = context.read(currentSongProvider.state).currentIndex;
          final totalDuration =
              context.read(musicProvider.state)[currentIndex].songDuration?.inSeconds ?? 0;
          // log('0.) currentDuration ${currentDuration.inSeconds} || Total Duration $totalDuration');

          /// Listen to current duration & total duration song
          /// If current duration exceeds the total song duration, Then Play Next Song
          if (currentDuration.inSeconds >= totalDuration) {
            final musics = context.read(musicProvider.state);
            final currentLoop = context.read(settingProvider.state).loopMode;

            /// Need Check Loop Mode
            /// If Mode is looping
            final result = context.read(currentSongProvider).nextSong(
                  musics,
                  loopModeSetting: currentLoop,
                  context: context,
                  players: players,
                );
            players.open(
              Audio.file(result.pathFile ?? '', metas: sharedParameter.metas(result)),
              showNotification: true,
              notificationSettings: sharedParameter.notificationSettings(
                context,
                musics: musics,
              ),
            );
          }
        }
      });
    });

    final watcher = DirectoryWatcher(ConstString.internalPathStorageAndroid);
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
              .whenComplete(() => context.read(musicProvider).addMusic(file.path));
        }

        ///* Detect if file has remove on storage
        if (event.type == ChangeType.REMOVE) {
          log('watching changes on storage Android $event\nPath : ${event.path}\nAction : ${event.type}');

          configFlutterLocalNotification
              .showPlanNotification(
                title: 'File Has Remove',
                body: '$basename Detect has Remove from application',
              )
              .then((_) => context.read(musicProvider).removeMusic(file.path));
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
    super.initState();
  }

  @override
  void dispose() {
    context.read(globalTimer).state?.cancel();
    context.read(globalAudioPlayers).state.dispose();
    super.dispose();
  }

  Future<void> minimizeApp() async {
    try {
      await ConstString.androidMinimizeChannel
          .invokeMethod<bool>(ConstString.androidMinimizeFunction);
    } on PlatformException catch (error) {
      log('platformException ${error.code} || ${error.details} || ${error.message}');
    } catch (e) {
      log('catch ${e.toString()} ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
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
      },
      child: Scaffold(
        backgroundColor: colorPallete.primaryColor,
        body: Consumer(
          builder: (context, watch, child) {
            final futureListMusic = watch(futureShowListMusic);
            return futureListMusic.when(
              data: (_) => IndexedStack(index: _selectedIndex, children: screens),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(
                  error.toString(),
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: InkWell(
          onTap: () => Navigator.of(context).pushNamed(MusicPlayerScreen.routeNamed),
          borderRadius: BorderRadius.circular(60),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundColor: colorPallete.accentColor,
              radius: sizes.width(context) / 12,
              foregroundColor: Colors.white,
              child: Icon(
                Icons.music_note_rounded,
                size: sizes.width(context) / 12,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBarWithFAB(
          backgroundColor: const Color(0xFF190226),
          selectedColor: Colors.white,
          unSelectedColor: Colors.white.withOpacity(.6),
          onTap: (currentIndex) {
            setState(() => _selectedIndex = currentIndex);
          },
          items: [
            BottomAppBarItem(iconData: Icons.home_rounded),
            BottomAppBarItem(iconData: Icons.more_vert_rounded),
          ],
        ),
      ),
    );
  }
}

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Setting Screen'),
    );
  }
}
