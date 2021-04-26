import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/my_config.dart';
import '../../../provider/my_provider.dart';

class HomeHeaderLongestListen extends StatelessWidget {
  const HomeHeaderLongestListen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizes.width(context),
      height: sizes.height(context) / 5,
      child: Consumer(
        builder: (context, watch, child) {
          final music = watch(longestListenSong).state;
          final _formatLongest = watch(formatLongestListenEachSong(music.idMusic)).state;
          return Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(.5)),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: ConstColor.backgroundColorGradient(),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: sizes.width(context) / 4,
                    right: sizes.width(context) / 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        music.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${music.tag?.artist ?? 'Unknown Artist'} | ${music.tag?.genre ?? 'Unknown Genre'}',
                        style: const TextStyle(color: Colors.white, fontSize: 8),
                      ),
                      const SizedBox(height: 20),
                      FittedBox(
                        child: Text(
                          _formatLongest,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w900, color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -20,
                left: 0,
                child: Container(
                  height: sizes.width(context) / 4.5,
                  width: sizes.width(context) / 4.5,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: music.artwork == null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            appConfig.fullPathImageAsset,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            music.artwork!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Positioned(
                right: -10,
                top: -20,
                child: Transform.rotate(
                  angle: .5,
                  child: const CircleAvatar(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: FittedBox(
                        child: Text('Terlama'),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
