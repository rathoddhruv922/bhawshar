import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:lottie/lottie.dart';

import 'app_text.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: SizedBox(
              width: 60.w,
              child: Lottie.asset('assets/empty_state.json'),
            ),
          ),
          const AppText(
            'Well, we are sad too but nothing to show here!',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
