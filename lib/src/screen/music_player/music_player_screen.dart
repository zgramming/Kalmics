import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/my_config.dart';
import '../../provider/my_provider.dart';

import './widgets/music_player_action_more.dart';
import './widgets/music_player_floating_v1.dart';
import './widgets/music_player_list.dart';
import './widgets/music_player_toggle_search.dart';

class MusicPlayerScreen extends StatelessWidget {
  static const routeNamed = '/music-player-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              ConstString.applicationName,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 24),
            ),
          ],
        ),
        actions: [
          const MusicPlayerToggleSearch(),
          MusicPlayerActionMore(),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(sizes.height(context) / 30),
          child: Consumer(
            builder: (_, watch, __) {
              final _totalMusic = watch(totalMusic).state;
              final _totalDurationMusic = watch(totalMusicDuration).state;
              final _counterTimer = watch(globalCounterTimer).state;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Lagu : $_totalMusic',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    if (_counterTimer != null)
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          const Icon(Icons.timer, color: Colors.white),
                          const SizedBox(width: 5),
                          Center(child: _counterTimer),
                        ],
                      ),
                    Text(
                      _totalDurationMusic,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
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
            context.read(isModeSearch).state = false;
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
                Consumer(
                  builder: (context, watch, child) {
                    final isSearch = watch(isModeSearch).state;

                    if (isSearch) {
                      return SizedBox.expand(child: Container(color: Colors.black45));
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
}
