import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../config/my_config.dart';
import '../../../provider/my_provider.dart';

class HomeHeaderTotalSongPlayed extends StatelessWidget {
  const HomeHeaderTotalSongPlayed({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            Expanded(
              child: Consumer(
                builder: (context, watch, child) {
                  final _initRecentsPlay = watch(initRecentPlayList);
                  final _recentsPlay = watch(recentPlayProvider.state).length;
                  if (_recentsPlay <= 0) {
                    return const Center(
                      child: Text(
                        'Data tidak cukup',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  return _initRecentsPlay.when(
                    data: (_) => Center(
                      child: Text(
                        GlobalFunction.abbreviateNumber(_recentsPlay),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
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
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                ConstString.accumulateSongPlayed,
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
    );
  }
}
