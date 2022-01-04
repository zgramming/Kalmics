import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/fonts.dart';

import 'widgets/song_info_item.dart';

class SongInfoPage extends StatelessWidget {
  static const routeNamed = '/song-info-page';
  const SongInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: monochromatic,
        centerTitle: true,
        title: Text(
          'Boku no Sensou',
          style: firaSansWhite.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: sizes.height(context) / 3,
            child: Image.asset(
              assetLogoPath,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Informasi',
                    style: firaSansWhite.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: ListTile.divideTiles(
                        tiles: const [
                          SongInfoItem(
                            legend: 'Judul',
                            value: 'Boku no Sensou',
                          ),
                          SongInfoItem(
                            legend: 'Artis',
                            value: 'Shinsei Kamattechan',
                          ),
                          SongInfoItem(
                            legend: 'Album',
                            value: 'Unknown',
                          ),
                          SongInfoItem(
                            legend: 'Tahun',
                            value: '2021',
                          ),
                        ],
                        color: darkGrey400,
                        context: context,
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
