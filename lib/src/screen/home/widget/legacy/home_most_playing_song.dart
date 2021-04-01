import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../network/my_network.dart';
import '../../../../provider/my_provider.dart';

// ignore: unused_element
class _HomeMostPlayingSong extends StatelessWidget {
  const _HomeMostPlayingSong({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizes.height(context) / 3.5,
      child: Consumer(
        builder: (_, watch, __) {
          final _future = watch(initRecentPlayList);
          return _future.when(
            data: (_) {
              final _recentsPlayMostPlayingSong = watch(recentsPlayMostPlayingSong).state;
              if (_recentsPlayMostPlayingSong.isEmpty) {
                return Center(
                  child: Text(
                    'Dengarkan lagu pertamamu !',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                );
              }
              final recentPlay = _recentsPlayMostPlayingSong['model'] as RecentPlayModel;
              final totalPlaying =
                  GlobalFunction.abbreviateNumber(_recentsPlayMostPlayingSong['total'] as int);
              return _HomeMostPlayingSongItem(
                recentPlay: recentPlay,
                totalPlaying: totalPlaying,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
          );
        },
      ),
    );
  }
}

class _HomeMostPlayingSongItem extends StatelessWidget {
  const _HomeMostPlayingSongItem({
    Key? key,
    required this.recentPlay,
    required this.totalPlaying,
  }) : super(key: key);

  final RecentPlayModel recentPlay;
  final String totalPlaying;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: recentPlay.music.artwork == null
                    ? Image.asset(
                        '${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}',
                        fit: BoxFit.cover,
                        width: sizes.width(context),
                        height: sizes.height(context),
                      )
                    : Image.memory(
                        recentPlay.music.artwork!,
                        fit: BoxFit.cover,
                        width: sizes.width(context),
                        height: sizes.height(context),
                      ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Paling banyak didengar'.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.openSans(color: Colors.white),
                    children: [
                      TextSpan(
                        text: totalPlaying,
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              color: Colors.green,
                              offset: Offset(2, 2),
                            )
                          ],
                          fontWeight: FontWeight.bold,
                          fontSize: totalPlaying.length >= 3 ? 60 : 80,
                        ),
                      ),
                      TextSpan(
                        text: ' kali ',
                        style: GoogleFonts.openSans(
                          fontSize: 8,
                        ),
                      ),
                      TextSpan(
                        text: recentPlay.music.title,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                      TextSpan(
                        text: ' Didengarkan',
                        style: GoogleFonts.openSans(
                          fontSize: 8,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
