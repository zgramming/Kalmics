import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/colors.dart';
import '../../onboarding/onboarding_page.dart';

class PercetageIndicator extends StatelessWidget {
  const PercetageIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, ref, child) {
          final _percetage = ref.watch(currentPercetageOnboarding);
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _percetage,
            child: child,
          );
        },
        child: Container(
          height: 10,
          decoration: const BoxDecoration(
            color: successColor,
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
