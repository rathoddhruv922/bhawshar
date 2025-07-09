import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AuthLogoWidget extends StatelessWidget {
  final bool isForgotPwdScreen;
  const AuthLogoWidget({super.key, this.isForgotPwdScreen = false});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: isForgotPwdScreen && 100.h <= 667
          ? 14.h
          : 100.h <= 667
              ? 10.5.h
              : 18.h,
      left: 0,
      right: 0,
      child: SvgPicture.asset('assets/svg/logo.svg', width: 50.w),
    );
  }
}
