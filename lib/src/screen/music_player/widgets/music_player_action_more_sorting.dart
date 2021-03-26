import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../config/my_config.dart';
import '../../../network/my_network.dart';
import '../../../provider/my_provider.dart';

class MusicPlayerActionMoreSorting extends StatelessWidget {
  const MusicPlayerActionMoreSorting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          context.read(settingProvider).setSortChoice(choice ?? '');
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: const Text('Judul'),
                        secondary: const Icon(Icons.title),
                      ),
                      RadioListTile<String>(
                        value: ConstString.sortChoiceByArtist,
                        groupValue: _settingProvider.sortChoice,
                        onChanged: (choice) {
                          context.read(settingProvider).setSortChoice(choice ?? '');
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: const Text('Artis'),
                        secondary: const Icon(Icons.person_search),
                      ),
                      RadioListTile<String>(
                        value: ConstString.sortChoiceByDuration,
                        groupValue: _settingProvider.sortChoice,
                        onChanged: (choice) {
                          context.read(settingProvider).setSortChoice(choice ?? '');
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
              final ascending = watch(styleAscDescButton(ConstString.ascendingValue)).state;
              final descending = watch(styleAscDescButton(ConstString.descendingValue)).state;

              return Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ascending,
                      onPressed: () {
                        context.read(settingProvider).setSortByType(SortByType.ascending);
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
                        context.read(settingProvider).setSortByType(SortByType.descending);
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
  }
}
