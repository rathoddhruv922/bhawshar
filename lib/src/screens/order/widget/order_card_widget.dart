import 'package:bhawsar_chemical/data/models/orders_model/item.dart' as orders;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../business_logic/bloc/order/order_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../generated/l10n.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../router/route_list.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_snackbar_toast.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_container_widget.dart';

enum OrderMenu { edit, delete, cancel }

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key? key,
    required this.order,
    required this.index,
  }) : super(key: key);

  final orders.Item order;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: false,
      color: offWhite,
      margin: const EdgeInsets.only(bottom: paddingDefault),
      elevation: 0.2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        tileColor: transparent,
        dense: true,
        contentPadding: const EdgeInsets.all(paddingSmall),
        minVerticalPadding: paddingExtraSmall,
        minLeadingWidth: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onTap: () async {
          await navigationKey.currentState?.pushNamed(RouteList.viewOrder, arguments: order.id).then((value) {
            if (value == true) {
              context.read<OrderBloc>()
                ..add(const ClearOrderEvent())
                ..add(const GetOrdersEvent(currentPage: 1, recordPerPage: 20));
            }
          });
        },
        title: Row(
          children: [
            const AppSpacerWidth(),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AppText(
                              (order.client ?? 'NA').toUpperCase(),
                              fontWeight: FontWeight.bold,
                              maxLine: 1,
                            ),
                          ),
                        ),
                        const AppSpacerWidth(width: paddingExtraSmall),
                        CommonContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          shadowColor: greyLight,
                          color: order.status?.toLowerCase() == 'new'
                              ? yellow.withOpacity(0.5)
                              : order.status?.toLowerCase() == 'cancel'
                                  ? grey.withOpacity(0.5)
                                  : order.status?.toLowerCase() == 'processing'
                                      ? secondary
                                      : order.status?.toLowerCase() == 'shipped'
                                          ? orange.withOpacity(0.8)
                                          : order.status?.toLowerCase() == 'delivered'
                                              ? primary.withOpacity(0.6)
                                              : order.status?.toLowerCase() == 'hold'
                                                  ? red.withOpacity(0.5)
                                                  : order.status?.toLowerCase() == 'complete'
                                                      ? primary
                                                      : yellow.withOpacity(0.5),
                          radius: 2,
                          child: AppText('${order.status?.toCapitalized()}',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: (order.status?.toLowerCase() == 'complete') ? offWhite : textBlack),
                        ),
                        (order.status?.toLowerCase() == 'new' ||
                                order.status?.toLowerCase() == 'zerosum' ||
                                order.status?.toLowerCase() == 'cancel')
                            ? order.inActiveProduct == 0
                                ? Tooltip(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: paddingSmall,
                                      vertical: paddingSmall,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: paddingMedium,
                                    ),
                                    showDuration: const Duration(seconds: 3),
                                    enableFeedback: true,
                                    message: localization.product_inactive_warning,
                                    triggerMode: TooltipTriggerMode.tap,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: paddingSmall,
                                      ),
                                      child: Icon(
                                        Icons.more_vert_rounded,
                                        color: grey,
                                      ),
                                    ),
                                  )
                                : PopupMenuButton(
                                    icon: const Icon(
                                      Icons.more_vert_rounded,
                                      color: primary,
                                    ),
                                    padding: EdgeInsets.zero,
                                    position: PopupMenuPosition.under,
                                    onSelected: (OrderMenu item) async {
                                      if (item == OrderMenu.edit) {
                                        order.status?.toLowerCase() == 'new' || order.status?.toLowerCase() == 'zerosum'
                                            ? await navigationKey.currentState
                                                ?.pushNamed(
                                                RouteList.updateOrder,
                                                arguments: order.id,
                                              )
                                                .then((value) {
                                                if (value == true) {
                                                  context.read<OrderBloc>()
                                                    ..add(const ClearOrderEvent())
                                                    ..add(const GetOrdersEvent(currentPage: 1, recordPerPage: 20));
                                                }
                                              })
                                            : null;
                                      } else if (item == OrderMenu.cancel) {
                                        try {
                                          order.status?.toLowerCase() == 'new'
                                              ? appAlertDialog(
                                                  context,
                                                  AppText(
                                                    S.of(context).confirmation,
                                                    textAlign: TextAlign.center,
                                                    fontSize: 17,
                                                  ),
                                                  () {
                                                    Navigator.of(context).pop();
                                                    context.read<OrderBloc>().add(
                                                          CancelOrderEvent(
                                                              status: "Cancel", orderId: order.id!, itemIndex: index),
                                                        );
                                                  },
                                                  () => Navigator.of(context).pop(),
                                                )
                                              : null;
                                        } catch (e) {
                                          showCatchedError(e);
                                        }
                                      } else if (item == OrderMenu.delete) {
                                        try {
                                          (order.status?.toLowerCase() == 'cancel' || order.status?.toLowerCase() == 'zerosum')
                                              ? appAlertDialog(
                                                  context,
                                                  AppText(
                                                    S.of(context).confirmation,
                                                    textAlign: TextAlign.center,
                                                    fontSize: 17,
                                                  ),
                                                  () {
                                                    Navigator.of(context).pop();
                                                    context.read<OrderBloc>().add(
                                                          DeleteOrderEvent(orderId: order.id!, itemIndex: index),
                                                        );
                                                  },
                                                  () => Navigator.of(context).pop(),
                                                )
                                              : mySnackbar(localization.delete_order_warning,
                                                  textColor: textBlack, bgColor: yellow);
                                        } catch (e) {
                                          showCatchedError(e);
                                        }
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<OrderMenu>>[
                                      PopupMenuItem(
                                        value: OrderMenu.edit,
                                        child: TextButton.icon(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.edit,
                                            color:
                                                (order.status?.toLowerCase() == 'new' || order.status?.toLowerCase() == 'zerosum')
                                                    ? textBlack
                                                    : grey,
                                          ),
                                          label: AppText(localization.edit,
                                              color: (order.status?.toLowerCase() == 'new' ||
                                                      order.status?.toLowerCase() == 'zerosum')
                                                  ? textBlack
                                                  : grey),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: OrderMenu.cancel,
                                        child: TextButton.icon(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.cancel,
                                            color: (order.status?.toLowerCase() == 'new') ? textBlack : grey,
                                          ),
                                          label: AppText(localization.cancel,
                                              color: (order.status?.toLowerCase() == 'new') ? textBlack : grey),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: OrderMenu.delete,
                                        child: TextButton.icon(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.delete,
                                            color: (order.status?.toLowerCase() == 'cancel' ||
                                                    order.status?.toLowerCase() == 'zerosum')
                                                ? textBlack
                                                : grey,
                                          ),
                                          label: AppText(
                                            localization.delete,
                                            color: (order.status?.toLowerCase() == 'cancel' ||
                                                    order.status?.toLowerCase() == 'zerosum')
                                                ? textBlack
                                                : grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                            : IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  mySnackbar("${localization.change_order_status_warning} ${order.status}.",
                                      textColor: textBlack, bgColor: yellow);
                                },
                                icon: const Icon(
                                  Icons.more_vert_rounded,
                                  color: grey,
                                )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonContainer(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 3,
                              offset: const Offset(0, 0.5), // changes position of shadow
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: const AppText(
                          '₹',
                          textAlign: TextAlign.center,
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const AppSpacerWidth(),
                      Expanded(
                        child: AppText(
                          order.total.toString() == "" || order.total.toString().contains('-1') == true
                              ? 'NA'
                              : currencyFormat.format(order.total), // check -1 when mr has no right to view price
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          order.type.toString().toLowerCase() == 'at shop' ? Icons.storefront : Icons.call_outlined,
                          size: 18,
                          color: primary,
                        ),
                      ),
                      const AppSpacerWidth(width: 20),
                      AppText(
                        getDate(order.createdAt, dateFormat: intl.DateFormat.yMMMd('en_US')),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      const AppSpacerWidth(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
