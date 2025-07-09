import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

class CommonContainer extends StatelessWidget {
  const CommonContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.margin,
    this.constraints,
    this.padding,
    this.border,
    this.color = white,
    this.radius = 0.0,
    this.decoration,
    this.shadowColor = grey,
  });

  final double? height;
  final double? width;
  final double radius;
  final Border? border;
  final Widget? child;
  final Color color;
  final BoxDecoration? decoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin, padding;
  final Color shadowColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? EdgeInsets.zero,
      constraints: constraints,
      decoration: decoration ??
          BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
            border: border,
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 3,
                offset: const Offset(0, 0.5), // changes position of shadow
              ),
            ],
          ),
      child: child,
    );
  }
}
