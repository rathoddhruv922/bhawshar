import 'package:bhawsar_chemical/src/screens/order/add_order/widget/search_item_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../business_logic/bloc/product/product_bloc.dart';
import '../../../../../constants/enums.dart';
import '../../../../../main.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../widgets/app_loader_simple.dart';
import '../../../../widgets/app_switcher_widget.dart';
import '../../../../widgets/app_text.dart';

class SearchItemWidget extends StatefulWidget {
  const SearchItemWidget(
      {super.key,
      required this.headerItem,
      required this.productItems,
      required this.giftItems,
      required this.popItems,
      required this.onChanged,
      required this.sampleItems,
      required this.nonProductive});

  final ValueChanged onChanged;
  final bool nonProductive;
  final List<Map<dynamic, dynamic>> productItems, giftItems, popItems, sampleItems;
  final int headerItem;

  @override
  State<SearchItemWidget> createState() => _SearchItemWidgetState();
}

class _SearchItemWidgetState extends State<SearchItemWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.status == ProductStatus.initial) {
          return AppSwitcherWidget(
            animationType: 'slide',
            direction: AxisDirection.left,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
              ),
              child: Center(
                child: AppText(
                    textAlign: TextAlign.center,
                    widget.headerItem == 0
                        ? localization.product_search_filter
                        : widget.headerItem == 1
                            ? localization.gift_search_filter
                            : widget.headerItem == 2
                                ? localization.pop_search_filter
                                : localization.sample_search_filter),
              ),
            ),
          );
        } else if (state.status == ProductStatus.loading) {
          return const AppLoader();
        } else if (state.status == ProductStatus.loaded) {
          return Container(
            color: white,
            child: SearchItemListWidget(
              nonProductive: widget.nonProductive,
              onChanged: widget.onChanged,
              state: state.res,
              id: widget.headerItem,
              productItems: widget.productItems,
              giftItems: widget.giftItems,
              popItems: widget.popItems,
              sampleItems: widget.sampleItems,
              // qtyController: qtyController,
            ),
          );
        } else if (state.status == ProductStatus.failure) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
            ),
            child: Center(
              child: AppText(
                state.msg.toString(),
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
        // return AppSwitcherWidget(
        //   animationType: 'slide',
        //   direction: AxisDirection.left,
        //   child: state.status == ProductStatus.initial
        //       ? Padding(
        //           padding: const EdgeInsets.only(
        //             top: 5.0,
        //           ),
        //           child: Center(
        //             child: AppText(
        //                 textAlign: TextAlign.center,
        //                 widget.headerItem == 0
        //                     ? localization.product_search_filter
        //                     : widget.headerItem == 1
        //                         ? localization.gift_search_filter
        //                         : widget.headerItem == 2
        //                             ? localization.pop_search_filter
        //                             : localization.sample_search_filter),
        //           ),
        //         )
        //       : state.status == ProductStatus.loading
        //           ? const AppLoader()
        //           : state.status == ProductStatus.failure
        //               ? Padding(
        //                   padding: const EdgeInsets.only(
        //                     top: 5.0,
        //                   ),
        //                   child: Center(
        //                     child: AppText(
        //                       state.msg.toString(),
        //                     ),
        //                   ),
        //                 )
        //               : state.status == ProductStatus.loaded
        //                   ? Container(
        //                       color: white,
        //                       child: SearchItemListWidget(
        //                         onChanged: widget.onChanged,
        //                         state: state.res,
        //                         id: widget.headerItem,
        //                         productItems: widget.productItems,
        //                         giftItems: widget.giftItems,
        //                         popItems: widget.popItems,
        //                         sampleItems: widget.sampleItems,
        //                         // qtyController: qtyController,
        //                       ),
        //                     )
        //                   : const SizedBox.shrink(),
        // );
      },
    );
  }
}
