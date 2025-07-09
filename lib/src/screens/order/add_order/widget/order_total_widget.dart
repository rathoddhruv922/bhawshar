import 'package:flutter/material.dart';

import '../../../../../constants/app_const.dart';
import '../../../../../helper/app_helper.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_text.dart';

class TotalWidget extends StatelessWidget {
  const TotalWidget({Key? key, required this.productItems}) : super(key: key);

  final List<Map<dynamic, dynamic>>? productItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                localization.pay,
                fontSize: 18,
                color: black,
              ),
              AppText(
                getTotalAmount(productItems),
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: black,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
