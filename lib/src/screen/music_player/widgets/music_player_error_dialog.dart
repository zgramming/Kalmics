import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/my_config.dart';
import '../../../provider/my_provider.dart';

class MusicPlayerErrorDialog extends StatelessWidget {
  final String error;

  const MusicPlayerErrorDialog({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: sizes.height(context) / 3,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    child: Image.asset(
                        '${appConfig.urlImageAsset}/${ConstString.assetIconErrorSongNotFound}'),
                  ),
                ),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.read(isLoading).state = true;
            context
                .refresh(initializeMusicFromStorage)
                .then((_) => context.read(isLoading).state = false)
                .then((value) => Navigator.of(context).pop());
          },
          style: ElevatedButton.styleFrom(primary: Colors.blue),
          child: Text(
            'Sinkron ulang',
            style: GoogleFonts.openSans().copyWith(color: Colors.white),
          ),
        )
      ],
    );
  }
}
