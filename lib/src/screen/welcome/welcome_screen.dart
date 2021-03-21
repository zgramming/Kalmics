import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/shared/my_shared.dart';

import '../../provider/my_provider.dart';

import '../home/home_screen.dart';
import '../music_player/music_player_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = '/welcome-screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final sharedParameter = SharedParameter();
  int _selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final players = context.read(globalAudioPlayers).state;

      players.currentPosition.listen((currentDuration) {
        context.read(currentSongProvider).setDuration(currentDuration);
        final currentIndex = context.read(currentSongProvider.state).currentIndex;
        final totalDuration =
            context.read(musicProvider.state)[currentIndex].totalDuration?.inSeconds ?? 0;
        log('0.) currentDuration ${currentDuration.inSeconds} || Total Duration $totalDuration');

        /// Listen to current duration & total duration song
        /// If current duration exceeds the total song duration, Then Play Next Song
        ///
        if (currentDuration.inSeconds >= totalDuration) {
          final musics = context.read(musicProvider.state);

          /// Need Check Loop Mode
          /// If Mode is looping
          final result = context.read(currentSongProvider).nextSong(musics);
          players.open(
            Audio.file(result.pathFile ?? '', metas: sharedParameter.metas(result)),
            showNotification: true,
            notificationSettings: sharedParameter.notificationSettings(
              context,
              musics: musics,
            ),
          );
        }
      });

      players.loopMode.listen((event) {
        log('1.) loopmode $event');
      });
      players.current.listen((event) {
        log('2.) currentListen $event');
      });
      players.isPlaying.listen((event) {
        log('3.) playingListen $event');
      });
      players.playerState.listen((state) {
        log('4.) playerStateListen $state');
        final _currentSong = context.read(currentSongProvider.state);
        switch (state) {
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

      players.playlistFinished.listen((finished) {
        if (finished) {
          log('5.) Finished song true $finished');
        } else {
          log('5.) Finished song false $finished');
        }
      });

      players.playlistAudioFinished.listen((playing) {
        log('6.) Finished song $playing');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPallete.primaryColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
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
