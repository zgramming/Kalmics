import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../config/my_config.dart';
import '../../provider/my_provider.dart';

import './widgets/music_player_appbar.dart';
import './widgets/music_player_floating_v1.dart';
import './widgets/music_player_list.dart';

class MusicPlayerScreen extends StatefulWidget {
  static const routeNamed = '/music-player-screen';

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    log('dispose on MusicPlayerScreen');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ProviderListener<StateController<bool>>(
        provider: isLoading,
        onChange: (context, value) {
          if (value.state) {
            GlobalFunction.showDialogLoading(context);
            return;
          }
          Navigator.of(context).pop();
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            context.read(globalSearch).state = false;
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: ConstColor.backgroundColorGradient(),
              ),
            ),
            child: Stack(
              children: [
                MusicPlayerList(),
                const FloatingMusicPlayerV1(),
                const MusicPlayerAppBar(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
