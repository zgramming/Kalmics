import 'package:flutter/material.dart';
import '../../../../utils/fonts.dart';

class SongInfoItem extends StatelessWidget {
  const SongInfoItem({
    Key? key,
    required this.legend,
    required this.value,
  }) : super(key: key);
  final String legend;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              legend,
              style: amikoWhite,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: amikoWhite,
            ),
          ),
        ],
      ),
    );
  }
}
