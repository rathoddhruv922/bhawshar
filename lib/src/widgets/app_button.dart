import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../utils/app_colors.dart';

class AppButton extends StatelessWidget {
  final String btnText;
  final Color? btnColor;

  final Color? btnTextColor;
  final double? btnFontSize;
  final double? btnHeight;
  final double? btnWidth;
  final double? btnRadius;
  final FontWeight? btnFontWeight;
  final Function()? onBtnClick;
  const AppButton(
      {Key? key,
      required this.btnText,
      this.btnColor,
      this.btnTextColor,
      this.btnFontSize,
      this.btnHeight,
      this.btnWidth,
      this.btnRadius,
      this.btnFontWeight,
      required this.onBtnClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor ?? primary,
        foregroundColor: btnTextColor ?? white,
        disabledForegroundColor: grey,
        minimumSize: Size(btnWidth ?? 88, btnHeight ?? 45),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(btnRadius ?? 8)),
        ),
      ),
      onPressed: onBtnClick,
      child: Text(
        btnText,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: btnFontSize ?? 17.sp,
            fontWeight: btnFontWeight ?? FontWeight.bold),
      ),
    );
  }
}
