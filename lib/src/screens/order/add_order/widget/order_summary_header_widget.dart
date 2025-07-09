import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../constants/app_const.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_text.dart';

class SubTotalHeaderWidget extends StatelessWidget {
  const SubTotalHeaderWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.symmetric(
          vertical: paddingExtraSmall, horizontal: paddingExtraSmall),
      margin: const EdgeInsets.symmetric(vertical: paddingDefault),
      color: greyLight,
      child: AppText(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
}
