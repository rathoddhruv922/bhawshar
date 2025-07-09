import 'package:flutter/material.dart';

import '../../../../constants/app_const.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_text.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      semanticContainer: false,
      margin: const EdgeInsets.all(paddingSmall),
      shadowColor: green,
      elevation: 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                '“ To help every individual enjoy one’s total health. ”\n― ${localization.app_name},',
                maxLine: 6,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
