import 'package:flutter/material.dart';

class AppSpacerHeight extends StatelessWidget {
  final double height;
  const AppSpacerHeight({
    Key? key,
    this.height = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class AppSpacerWidth extends StatelessWidget {
  final double width;
  const AppSpacerWidth({
    Key? key,
    this.width = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
