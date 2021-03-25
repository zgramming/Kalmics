import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../provider/my_provider.dart';
import './widgets/music_player_action_more.dart';
import './widgets/music_player_floating_v1.dart';
import './widgets/music_player_list.dart';
import './widgets/music_player_toggle_search.dart';

class MusicPlayerScreen extends StatefulWidget {
  static const routeNamed = '/music-player-screen';

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPallete.primaryColor,
      appBar: AppBar(
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
          child: Stack(
            children: [
              MusicPlayerList(),
              const FloatingMusicPlayerV1(),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
