import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import 'app_text.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
                width: 60.w,
                child: Lottie.asset('assets/internet_connection.json')),
          ),
          AppText(
            localization.network_error,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
