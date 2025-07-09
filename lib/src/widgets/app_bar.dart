import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget title;
  final List<Widget>? action;
  final Widget? leading;
  final Color bg;
  final bool? isCenterTile;

  const CustomAppBar(
    this.title, {
    this.leading,
    this.action,
    this.bg = secondary,
    this.isCenterTile = true,
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: isCenterTile,
      backgroundColor: bg,
      leadingWidth: 45,
      leading: leading,
      title: title,
      actions: action,
      automaticallyImplyLeading: false,
    );
  }
}
