import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../../utils/fonts.dart';

class MoreOptionItem extends StatelessWidget {
  const MoreOptionItem({
    Key? key,
    required this.leadingIcon,
    required this.leadingIconColor,
    this.title = '',
    this.subtitle = '',
    required this.onTap,
  }) : super(key: key);

  final IconData leadingIcon;
  final Color leadingIconColor;
  final String title;
  final String subtitle;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: IconButton(
        onPressed: null,
        icon: Icon(
          leadingIcon,
          color: leadingIconColor,
        ),
      ),
      title: Text(
        title,
        style: firaSans.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: amikoGrey400.copyWith(fontSize: 10.0),
      ),
      trailing: const IconButton(
        onPressed: null,
        icon: Icon(FeatherIcons.chevronRight),
      ),
    );
  }
}
