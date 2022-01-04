import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/fonts.dart';
import '../../../../utils/navigation.dart';
import '../../../widgets/modal_bottomsheet_header_indicator.dart';
import '../../song_edit/song_edit_page.dart';
import '../../song_info/song_info_page.dart';
import 'more_option_item.dart';

class MBSMoreOptionSong extends StatelessWidget {
  const MBSMoreOptionSong({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ModalBottomSheetHeaderIndicator(),
          MoreOptionItem(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Konfirmasi',
                    style: firaSans.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Kamu akan menghapus '),
                        TextSpan(
                          text: 'Sheiso no Sensou ',
                          style: amiko.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: 'dari perangkat kamu. '),
                        const TextSpan(
                          text:
                              'Aksi ini tidak dapat dibatalkan dan lagu tidak dapat dikembalikan kembali.',
                        ),
                      ],
                    ),
                    style: amiko.copyWith(
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: const Text('Hapus'),
                    ),
                    OutlinedButton(
                      onPressed: () => globalNavigation.pop(),
                      child: const Text('Batal'),
                    ),
                  ],
                ),
              );
            },
            leadingIcon: FeatherIcons.delete,
            leadingIconColor: Colors.red,
            title: 'Hapus',
            subtitle: 'Menghapus lagu dari perangkat kamu',
          ),
          MoreOptionItem(
            onTap: () {},
            leadingIcon: FeatherIcons.heart,
            leadingIconColor: primary,
            title: 'Aku Suka Kamu',
            subtitle: 'Menambahkan lagu ke daftar kesukaan kamu',
          ),
          MoreOptionItem(
            onTap: () async => globalNavigation.pushNamed(routeName: SongEditPage.routeNamed),
            leadingIcon: FeatherIcons.edit,
            leadingIconColor: infoColor,
            title: 'Edit',
            subtitle: 'Mengubah informasi lagu',
          ),
          MoreOptionItem(
            onTap: () async => globalNavigation.pushNamed(routeName: SongInfoPage.routeNamed),
            leadingIcon: FeatherIcons.info,
            leadingIconColor: infoColor,
            title: 'Detail',
            subtitle: 'Menampilan berbagai informasi lagu',
          ),
        ],
      ),
    );
  }
}
