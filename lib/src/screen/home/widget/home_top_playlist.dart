import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/my_config.dart';
import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';

class HomeTopPlaylist extends StatelessWidget {
  const HomeTopPlaylist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, __) {
        final _future = watch(initRecentPlayList);
        return _future.when(
          data: (_) {
            final top5Chart = watch(recentsPlay5TopChart).state;
            if (top5Chart.isEmpty) {
              return const SizedBox();
            }
            return Column(
              children: [
                Text(
                  ConstString.mostSongPlayed,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: top5Chart.length,
                  itemBuilder: (context, index) {
                    final music = top5Chart.keys.elementAt(index);
                    final total =
                        GlobalFunction.abbreviateNumber(top5Chart.values.elementAt(index));
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(1.5, 1.5),
                                  ),
                                ],
                              ),
                              child: music.artwork == null
                                  ? Image.asset(
                                      appConfig.fullPathImageAsset,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.memory(
                                      music.artwork!,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 4,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final maxWidth = constraints.maxWidth;
                                final _increasePercentace = increasePercentace(
                                    map: top5Chart,
                                    maxWidthLayoutBuilder: maxWidth,
                                    totalSongPlayedItem: top5Chart.values.elementAt(index));
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      music.title ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.openSans(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      music.tag?.artist ?? '',
                                      style: GoogleFonts.openSans(
                                        color: Colors.white,
                                        fontSize: 9,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      height: 20,
                                      margin: EdgeInsets.only(right: _increasePercentace),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green,
                                            blurRadius: 2,
                                            offset: Offset(2, 2),
                                          )
                                        ],
                                        borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  total,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
        );
      },
    );
  }

  double increasePercentace({
    required Map<MusicModel, int> map,
    required double maxWidthLayoutBuilder,
    required int totalSongPlayedItem,
  }) {
    final mostPlayedSong = map.values.reduce((curr, next) => curr > next ? curr : next);
    final result =
        maxWidthLayoutBuilder * ((mostPlayedSong - totalSongPlayedItem) / mostPlayedSong);
    return result;
  }
}
