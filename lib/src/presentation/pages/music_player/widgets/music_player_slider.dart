import 'package:flutter/material.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/fonts.dart';

class MusicPlayerSlider extends StatelessWidget {
  const MusicPlayerSlider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '00.00',
              style: amikoWhite.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Slider(
              value: 8,
              max: 20,
              onChanged: (value) => '',
              thumbColor: monochromatic2,
              activeColor: secondary,
              inactiveColor: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              '04.10',
              style: amikoWhite.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
