import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../provider/my_provider.dart';

class MusicPlayerDetailInfoTotalPlaying extends ConsumerWidget {
  final String idMusic;
  const MusicPlayerDetailInfoTotalPlaying({
    required this.idMusic,
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _music = watch(musicById(idMusic)).state;
    final totalPlaying = watch(recentsTotalPlayingEachSong(idMusic)).state;
    final abbreviateTotalPlaying = GlobalFunction.abbreviateNumber(totalPlaying);
    return SizedBox(
      height: sizes.height(context) / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _music.artwork == null
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.asset(
                      '${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}',
                      fit: BoxFit.cover,
                      width: sizes.width(context),
                      height: sizes.height(context),
                    ),
                  )
                : ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.memory(
                      _music.artwork!,
                      fit: BoxFit.cover,
                      width: sizes.width(context),
                      height: sizes.height(context),
                    ),
                  ),
          ),
          Expanded(
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.openSans(
                    color: colorPallete.accentColor,
                  ),
                  children: [
                    TextSpan(
                      text: abbreviateTotalPlaying,
                      style: GoogleFonts.openSans(
                        color: colorPallete.accentColor,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(.5),
                            offset: const Offset(2, 2),
                          )
                        ],
                        fontWeight: FontWeight.bold,
                        fontSize: abbreviateTotalPlaying.length >= 3 ? 40 : 60,
                      ),
                    ),
                    TextSpan(
                      text: ' kali ',
                      style: GoogleFonts.openSans(
                        fontSize: 8,
                      ),
                    ),
                    TextSpan(
                      text: _music.title,
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
          ),
        ],
      ),
    );
  }
}
