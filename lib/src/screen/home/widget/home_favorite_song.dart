import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home_screen.dart';

class HomeFavoriteSong extends StatelessWidget {
  const HomeFavoriteSong({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lagu Favoritku',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Text(
              'Lihat Selengkapnya',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 10,
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: sizes.height(context) / 8,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: listRecentPlay.length,
            shrinkWrap: true,
            itemExtent: sizes.width(context) / 4,
            itemBuilder: (context, index) {
              final result = listRecentPlay[index];
              return SizedBox(
                child: ShowImageNetwork(
                  padding: const EdgeInsets.all(8.0),
                  imageUrl: result.imageUrl,
                  imageBorderRadius: BorderRadius.circular(10),
                  imageSize: 1,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
