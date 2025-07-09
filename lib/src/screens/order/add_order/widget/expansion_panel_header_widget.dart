import 'package:flutter/material.dart';

import '../../../../../constants/app_const.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_spacer.dart';
import '../../../../widgets/app_text.dart';
import '../../../common/common_container_widget.dart';

class ExpansionPanelHeaderWidget extends StatelessWidget {
  const ExpansionPanelHeaderWidget({
    Key? key,
    required this.headerItem,
    required this.productItems,
    required this.giftItems,
    required this.popItems,
    required this.sampleItems,
  }) : super(key: key);

  final List<Map> productItems;
  final List<Map> giftItems;
  final List<Map> popItems;
  final int headerItem;
  final List<Map> sampleItems;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.only(left: paddingMedium + 2),
      dense: true,
      key: Key(headerItem.toString()),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            headerItem == 0
                ? localization.product_add
                : headerItem == 1
                    ? localization.gift_add
                    : headerItem == 2
                        ? localization.pop_add
                        : localization.sample_add,
            color: textBlack,
            fontWeight: FontWeight.bold,
          ),
          const AppSpacerWidth(),
          if(headerItem != 0)
          CommonContainer(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: AppText(
              headerItem == 0
                  ? productItems.length.toString()
                  : headerItem == 1
                      ? giftItems.length.toString()
                      : headerItem == 2
                          ? popItems.length.toString()
                          : sampleItems.length.toString(),
              color: textBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
