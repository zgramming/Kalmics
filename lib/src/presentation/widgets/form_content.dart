import 'package:flutter/material.dart';
import '../../utils/fonts.dart';

class FormContent extends StatelessWidget {
  const FormContent({
    Key? key,
    required this.title,
    required this.child,
    this.titleStyle,
  }) : super(key: key);

  final String title;
  final Widget child;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: titleStyle ??
              amiko.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}
