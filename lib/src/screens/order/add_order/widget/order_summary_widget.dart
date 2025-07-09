import 'package:flutter/material.dart';

import '../../../../../constants/app_const.dart';
import '../../../../../main.dart';
import '../../../../widgets/app_text.dart';
import 'cart_item_widget.dart';
import 'order_summary_header_widget.dart';

class OrderSummaryWidget extends StatelessWidget {
  const OrderSummaryWidget({
    super.key,
    required this.productItems,
    required this.giftItems,
    required this.popItems,
    required this.sampleItems,
  });

  final List<Map<dynamic, dynamic>> productItems,
      giftItems,
      popItems,
      sampleItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: paddingDefault),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          AppText(
            localization.order_summary,
            fontSize: 18,
          ),
          SubTotalHeaderWidget(title: localization.product),
          if(productItems.isEmpty)
          Center(
            child: AppText(
              localization.not_interested_in_any_product,
              fontSize: 18,
            ),
          ),
          CartItemWidget(
            id: 0,
            isOrderSummary: true,
            productItems: productItems,
            giftItems: giftItems,
            popItems: popItems,
            sampleItems: sampleItems,
          ),
          giftItems.isNotEmpty
              ? SubTotalHeaderWidget(title: localization.gift)
              : const SizedBox.shrink(),
          CartItemWidget(
            id: 1,
            isOrderSummary: true,
            productItems: productItems,
            giftItems: giftItems,
            popItems: popItems,
            sampleItems: sampleItems,
          ),
          popItems.isNotEmpty
              ? SubTotalHeaderWidget(title: localization.pop)
              : const SizedBox.shrink(),
          CartItemWidget(
            id: 2,
            isOrderSummary: true,
            productItems: productItems,
            giftItems: giftItems,
            popItems: popItems,
            sampleItems: sampleItems,
          ),
          sampleItems.isNotEmpty
              ? SubTotalHeaderWidget(title: localization.sample)
              : const SizedBox.shrink(),
          CartItemWidget(
            id: 3,
            isOrderSummary: true,
            productItems: productItems,
            giftItems: giftItems,
            popItems: popItems,
            sampleItems: sampleItems,
          ),
        ],
      ),
    );
  }
}
