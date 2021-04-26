import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:kalmics/src/provider/music/recent_play/recent_play_provider.dart';

import '../../../config/my_config.dart';
import '../../../provider/music/music/music_provider.dart';

import './home_header_longest_listen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 30,
      children: [
        const HomeHeaderLongestListen(),
        SizedBox(
          width: sizes.width(context) / 2.125,
          height: sizes.height(context) / 8,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(.5)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: ConstColor.backgroundColorGradient(),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 5),
                Consumer(
                  builder: (context, watch, child) {
                    final _totalListenSongDuration = watch(formatTotalDurationListenSong).state;
                    return Text(
                      _totalListenSongDuration,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Akumulasi durasi lagu yang sudah dimainkan selama ini',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 9,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: sizes.width(context) / 2.125,
          height: sizes.height(context) / 8,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(.5)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: ConstColor.backgroundColorGradient(),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 5),
                Consumer(
                  builder: (context, watch, child) {
                    final _initRecentsPlay = watch(initRecentPlayList);
                    final _recentsPlay = watch(recentPlayProvider.state).length;
                    if (_recentsPlay <= 0) {
                      return const SizedBox();
                    }
                    return _initRecentsPlay.when(
                      data: (_) => Text(
                        GlobalFunction.abbreviateNumber(_recentsPlay),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stackTrace) => Center(
                        child: Text(error.toString()),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Akumulasi total lagu yang sudah dimainkan selama ini',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 9,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
