import 'package:bhawsar_chemical/data/models/order_model/product.dart' as order_product;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/order/order_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../constants/enums.dart';
import '../../../../data/models/order_model/order_model.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_separator_widget.dart';
import '../../../widgets/app_snackbar_toast.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_medical_card_widget.dart';
import '../add_order/widget/order_summary_widget.dart';
import '../add_order/widget/order_total_widget.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<dynamic, dynamic>> productItems = [];
  List<Map<dynamic, dynamic>> giftItems = [];
  List<Map<dynamic, dynamic>> popItems = [];
  List<Map<dynamic, dynamic>> sampleItems = [];

  @override
  void initState() {
    context.read<OrderBloc>().add(GetOrderEvent(orderId: widget.orderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      appBar: CustomAppBar(
        AppText(
          localization.order_detail,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        child: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state.status == OrderStatus.load) {
              OrderModel? order;
              setState(() {
                try {
                  order = state.res;
                } catch (e) {
                  showCatchedError(e);
                }
                if (order?.order?.id != null && (order?.order?.items?.isNotEmpty ?? true)) {
                  try {
                    order?.order?.items?.forEach((element) {
                      if (element.productType?.toLowerCase() == 'product') {
                        productItems.add({
                          'productId': element.product?.id,
                          'product': element.product as order_product.Product,
                          'price': double.parse(currencyFormat.format(element.price)),
                          'qty': element.quantity,
                          'size': element.size,
                          'size_id': element.productSizeId,
                          'productSizeId': element.productSizeId,
                          'add_item': true,
                          'scheme': element.scheme,
                          'schemeApplied': element.schemeApplied == 1 ? true : false,
                          'not_intrested': element.notIntrested,
                        });
                      } else if (element.productType?.toLowerCase() == 'gift article') {
                        giftItems.add({
                          'gift': element.product,
                          'price': double.parse(currencyFormat.format(element.price)),
                          'qty': element.quantity,
                          'size': element.size,
                          'size_id': element.productSizeId,
                          'scheme': element.scheme,
                          'schemeApplied': 0,
                        });
                      } else if (element.productType?.toLowerCase() == 'pop material') {
                        popItems.add({
                          'pop': element.product,
                          'price': double.parse(currencyFormat.format(element.price)),
                          'qty': element.quantity,
                          'size': element.size,
                          'size_id': element.productSizeId,
                          'scheme': element.scheme,
                          'schemeApplied': 0,
                        });
                      } else if (element.productType?.toLowerCase() == 'free sample') {
                        sampleItems.add({
                          'sample': element.product,
                          'price': double.parse(currencyFormat.format(element.price)),
                          'qty': element.quantity,
                          'size': element.size,
                          'size_id': element.productSizeId,
                          'scheme': element.scheme,
                          'schemeApplied': 0,
                        });
                      }
                    });
                  } catch (e) {
                    showCatchedError(e);
                  }
                }
                if (order?.order?.nonIntrestedItems?.isNotEmpty ?? false) {
                  try {
                    order?.order?.nonIntrestedItems?.forEach((element) {
                      productItems.add({
                        'productId': element.product?.id,
                        'product': element.product as order_product.Product,
                        'price': double.parse(currencyFormat.format(element.price)),
                        'qty': element.quantity,
                        'size': element.size,
                        'size_id': element.productSizeId,
                        'productSizeId': element.productSizeId,
                        'add_item': false,
                        'scheme': element.scheme,
                        'schemeApplied': element.schemeApplied == 1 ? true : false,
                        'not_intrested': element.notIntrested,
                      });
                    });
                  } catch (e) {
                    showCatchedError(e);
                  }
                }
              });
              Navigator.of(context).pop();
            } else if (state.status == OrderStatus.failure) {
              Navigator.of(context).pop();
              mySnackbar(state.msg.toString(), isError: true);
            }
          },
          builder: (context, state) {
            if (state.status == OrderStatus.load) {
              OrderModel order = state.res;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100.h <= 667 ? 17.h : 16.h,
                    child: Stack(
                      children: [
                        Positioned(child: Container(height: 8.h, color: secondary)),
                        Positioned(child: GlobalMedicalCard(dynamicMedicalInfo: order.order)),
                      ],
                    ),
                  ),
                  SafeArea(
                    // height: 84.h,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: paddingSmall),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        (order.order?.type?.toLowerCase() == 'mr' ||
                                (order.order?.items?.isEmpty ?? true) ||
                                order.order?.status == 'ZeroSum')
                            ? SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: paddingDefault),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: paddingSmall, vertical: paddingDefault),
                                  minLeadingWidth: 0,
                                  dense: true,
                                  tileColor: offWhite,
                                  minVerticalPadding: 0,
                                  horizontalTitleGap: 0,
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                          order.order?.distributor?.type?.toString().toLowerCase() == 'distributor'
                                              ? localization.distributor
                                              : localization.warehouse,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                      const MySeparator(),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: AppText(
                                              '${order.order?.distributor?.name}',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.pin_drop, color: primary),
                                      const AppSpacerWidth(),
                                      Flexible(
                                        child: AppText(
                                          '${order.order?.distributor?.area}, ',
                                          fontSize: 16,
                                        ),
                                      ),
                                      AppText(
                                        '${order.order?.distributor?.city}, ',
                                        fontSize: 16,
                                      ),
                                      AppText(
                                        '${order.order?.distributor?.state}',
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        order.order?.status == 'ZeroSum'
                            ? SizedBox.shrink()
                            : const Divider(
                                indent: paddingDefault,
                                endIndent: paddingDefault,
                                color: grey,
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: paddingDefault),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(localization.order_type, fontWeight: FontWeight.bold),
                              const AppSpacerWidth(width: 5),
                              AppText('${order.order?.type}'.toUpperCase()),
                            ],
                          ),
                        ),
                        const Divider(
                          indent: paddingDefault,
                          endIndent: paddingDefault,
                          color: grey,
                        ),
                        Visibility(
                          visible: order.order!.reminder!.dateTime == null ? false : true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: paddingDefault),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: paddingSmall, vertical: paddingDefault),
                              minLeadingWidth: 0,
                              dense: true,
                              tileColor: offWhite,
                              minVerticalPadding: 0,
                              horizontalTitleGap: 0,
                              title: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(localization.reminder, fontSize: 17, fontWeight: FontWeight.bold),
                                  const MySeparator(),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppText(localization.date, fontWeight: FontWeight.bold),
                                      const AppSpacerWidth(width: 5),
                                      AppText('${order.order?.reminder?.dateTime}'),
                                    ],
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppText(localization.message, fontWeight: FontWeight.bold),
                                        const AppSpacerWidth(width: 5),
                                        Flexible(
                                          child: AppText(maxLine: 50, '${order.order?.reminder?.message}'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: order.order?.reminder?.dateTime == null ? false : true,
                          child: const Divider(
                            indent: paddingDefault,
                            endIndent: paddingDefault,
                            color: grey,
                          ),
                        ),
                        Visibility(
                          visible: order.order!.notes!.isEmpty ? false : true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: paddingDefault),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(localization.special_note, fontWeight: FontWeight.bold),
                                const AppSpacerWidth(width: 5),
                                Flexible(child: AppText('${order.order?.notes}')),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: order.order!.notes!.isEmpty ? false : true,
                          child: const Divider(
                            indent: paddingDefault,
                            endIndent: paddingDefault,
                            color: grey,
                          ),
                        ),
                        (order.order?.items?.isEmpty ?? true) && (order.order?.nonIntrestedItems?.isEmpty ?? true)
                            ? SizedBox.shrink()
                            : OrderSummaryWidget(
                                productItems: productItems,
                                giftItems: giftItems,
                                popItems: popItems,
                                sampleItems: sampleItems,
                              ),
                        (order.order?.items?.isEmpty ?? true) && (order.order?.nonIntrestedItems?.isEmpty ?? true)
                            ? SizedBox.shrink()
                            : TotalWidget(productItems: productItems),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
