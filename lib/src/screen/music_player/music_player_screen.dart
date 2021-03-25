import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/config/my_config.dart';
import 'package:kalmics/src/network/my_network.dart';

import '../../provider/my_provider.dart';

import 'widgets/music_player_floating_v1.dart';
import 'widgets/music_player_list.dart';
import 'widgets/music_player_toggle_search.dart';

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
          // IconButton(
          //   icon: const Icon(Icons.sync_rounded),
          //   onPressed: () {
          //     context.read(isLoading).state = true;
          //     context
          //         .refresh(futureShowListMusic)
          //         .whenComplete(() => context.read(isLoading).state = false);
          //   },
          //   tooltip: 'Sinkron dengan system',
          // ),
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 'sync':
                  context.read(isLoading).state = true;
                  context
                      .refresh(futureShowListMusic)
                      .whenComplete(() => context.read(isLoading).state = false);
                  break;
                case 'sort':
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return SizedBox(
                        height: sizes.height(context) / 2,
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Consumer(
                                  builder: (context, watch, child) {
                                    final _settingProvider = watch(settingProvider.state);
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        RadioListTile<String>(
                                          value: ConstString.sortChoiceByTitle,
                                          groupValue: _settingProvider.sortChoice,
                                          onChanged: (choice) {
                                            context
                                                .read(settingProvider)
                                                .setSortChoice(choice ?? '');
                                          },
                                          controlAffinity: ListTileControlAffinity.trailing,
                                          title: const Text('Judul'),
                                          secondary: const Icon(Icons.title),
                                        ),
                                        RadioListTile<String>(
                                          value: ConstString.sortChoiceByArtist,
                                          groupValue: _settingProvider.sortChoice,
                                          onChanged: (choice) {
                                            context
                                                .read(settingProvider)
                                                .setSortChoice(choice ?? '');
                                          },
                                          controlAffinity: ListTileControlAffinity.trailing,
                                          title: const Text('Artis'),
                                          secondary: const Icon(Icons.person_search),
                                        ),
                                        RadioListTile<String>(
                                          value: ConstString.sortChoiceByDuration,
                                          groupValue: _settingProvider.sortChoice,
                                          onChanged: (choice) {
                                            context
                                                .read(settingProvider)
                                                .setSortChoice(choice ?? '');
                                          },
                                          controlAffinity: ListTileControlAffinity.trailing,
                                          title: const Text('Durasi'),
                                          secondary: const Icon(Icons.timer),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            Consumer(
                              builder: (_, watch, __) {
                                final ascending = watch(styleAscDescButton(0)).state;
                                final descending = watch(styleAscDescButton(1)).state;

                                return Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ascending,
                                        onPressed: () {
                                          context
                                              .read(settingProvider)
                                              .setSortByType(SortByType.ascending);
                                        },
                                        icon: const Icon(Icons.arrow_upward_rounded),
                                        label: const Text('Ascending'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: descending,
                                        onPressed: () {
                                          context
                                              .read(settingProvider)
                                              .setSortByType(SortByType.descending);
                                        },
                                        label: const Text('Descending'),
                                        icon: const Icon(Icons.arrow_downward_rounded),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  );
                  break;
                default:
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'sync',
                child: Row(
                  children: const [
                    Icon(Icons.sync_alt_rounded, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Sinkron lagu'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: const [
                    Icon(Icons.sort, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Urut berdasarkan'),
                  ],
                ),
              ),
            ],
          ),
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
