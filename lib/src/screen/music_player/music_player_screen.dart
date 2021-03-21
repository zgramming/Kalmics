import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../provider/my_provider.dart';

import 'widgets/music_player_floating_v1.dart';
import 'widgets/music_player_list.dart';
import 'widgets/music_player_toggle_search.dart';

class MusicPlayerScreen extends StatefulWidget {
  static const routeNamed = '/music-player-screen';

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener<StateController<bool>>(
      provider: isLoading,
      onChange: (context, _isLoading) {
        log('listen ${_isLoading.state}');
        if (_isLoading.state) {
          GlobalFunction.showDialogLoading(context);
        }
        Future.delayed(const Duration(milliseconds: 300), () => Navigator.of(context).pop());
      },
      child: Scaffold(
        backgroundColor: colorPallete.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text(
            'Kalmics',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          actions: [
            // IconButton(
            //     icon: const Icon(Icons.stop_rounded),
            //     onPressed: () {
            //       final players = context.read(globalAudioPlayers).state;
            //       final _currentSongProvider = context.read(currentSongProvider);
            //       _currentSongProvider.stopSong();
            //       players.stop();
            //     }),
            const MusicPlayerToggleSearch(),
            IconButton(
              icon: const Icon(Icons.sync_rounded),
              onPressed: () {
                context.read(isLoading).state = true;
                context.refresh(futureShowListMusic);
              },
              tooltip: 'Sinkron dengan system',
            ),
            IconButton(
                icon: const Icon(Icons.filter_alt_rounded),
                tooltip: 'Filter sesuai seleramu',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SizedBox(
                      height: sizes.screenHeightMinusAppBarAndStatusBar(context) / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Filter Berdasarkan : ',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  RadioListTile<String>(
                                    value: '1',
                                    groupValue: '1',
                                    title: Text('data'),
                                    subtitle: Text('data12'),
                                    secondary: Icon(Icons.album),
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    onChanged: (value) {},
                                  ),
                                  RadioListTile<String>(
                                    value: '1',
                                    groupValue: '1',
                                    title: Text('data'),
                                    subtitle: Text('data12'),
                                    secondary: Icon(Icons.person_search_sharp),
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    onChanged: (value) {},
                                  ),
                                  RadioListTile<String>(
                                    value: '1',
                                    groupValue: '1',
                                    title: Text('data'),
                                    subtitle: Text('data12'),
                                    secondary: Icon(Icons.category),
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            context.read(globalSearch).state = false;
          },
          child: Stack(
            children: [
              MusicPlayerList(),
              const FloatingMusicPlayerV1(),
              Consumer(
                builder: (context, watch, child) {
                  final isSearch = watch(globalSearch).state;
                  if (isSearch) {
                    return SizedBox.expand(
                      child: Container(
                        color: Colors.black45,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
