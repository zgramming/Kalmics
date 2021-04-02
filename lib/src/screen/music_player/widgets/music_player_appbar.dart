import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './music_player_action_more.dart';
import './music_player_toggle_search.dart';

class MusicPlayerAppBar extends StatelessWidget {
  const MusicPlayerAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight * 1.5,
      child: AppBar(
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
          const MusicPlayerToggleSearch(),
          MusicPlayerActionMore(),
        ],
      ),
    );
  }
}
