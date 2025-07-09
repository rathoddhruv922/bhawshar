import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utils/app_colors.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextOverflow textOverflow;
  final int maxLine;
  final Color? color, bg;
  final bool softWrap;
  final TextAlign textAlign;
  final bool isUnderline;
  final bool isLineThrough;
  final TextStyle? textTheme;

  const AppText(
    this.text, {
    Key? key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
    this.textOverflow = TextOverflow.ellipsis,
    this.maxLine = 2,
    this.color,
    this.bg,
    this.textTheme,
    this.softWrap = true,
    this.textAlign = TextAlign.left,
    this.isUnderline = false,
    this.isLineThrough = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverflow,
      maxLines: maxLine,
      textAlign: textAlign,
      softWrap: softWrap,
      style: textTheme ??
          Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: fontSize.sp,
              color: color ?? textBlack,
              fontWeight: fontWeight,
              backgroundColor: bg ?? transparent,
              decoration: isUnderline
                  ? TextDecoration.underline
                  : isLineThrough
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
    );
  }
}
