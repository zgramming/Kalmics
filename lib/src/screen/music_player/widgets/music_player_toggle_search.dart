import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/provider/my_provider.dart';

class MusicPlayerToggleSearch extends StatelessWidget {
  const MusicPlayerToggleSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final isSearch = watch(globalSearch).state;
        if (isSearch) {
          return SizedBox(
            width: sizes.width(context) / 2,
            child: TextFormFieldCustom(
              autoFocus: true,
              prefixIcon: null,
              maxLines: 1,
              controller: TextEditingController(text: context.read(searchQuery).state),
              textStyle: GoogleFonts.openSans(color: Colors.white),
              onFieldSubmitted: (value) {
                context.read(globalSearch).state = false;
                context.read(searchQuery).state = value;
              },
              onChanged: (value) {
                context.read(searchQuery).state = value;
              },
            ),
          );
        }
        return IconButton(
          icon: const Icon(Icons.search_rounded),
          tooltip: 'Cari lagu kesukaanmu',
          onPressed: () => context.read(globalSearch).state = true,
        );
      },
    );
  }
}
