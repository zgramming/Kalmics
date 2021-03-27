import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/config/my_config.dart';

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

  int _selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    SettingScreen(),
  ];

  Timer? timer;

  @override
  void initState() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      SharedFunction.initAudioPlayers(context, timer: timer);
      SharedFunction.initWatcher(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    context.read(globalTimer).state?.cancel();
    context.read(globalAudioPlayers).state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => SharedFunction.onBackButtonPressed(context),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ...ConstColor.backgroundColorGradient(),
              ],
            ),
          ),
          child: Consumer(
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
          onTap: (currentIndex) => setState(() => _selectedIndex = currentIndex),
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
