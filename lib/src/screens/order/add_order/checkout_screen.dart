import 'package:bhawsar_chemical/business_logic/bloc/order/order_bloc.dart';
import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/constants/enums.dart';
import 'package:bhawsar_chemical/data/models/medical_model/item.dart' as medical;
import 'package:bhawsar_chemical/helper/app_helper.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/router/route_list.dart';
import 'package:bhawsar_chemical/src/screens/common/common_medical_card_widget.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/order_summary_widget.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/order_total_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_animated_dialog.dart';
import 'package:bhawsar_chemical/src/widgets/app_bar.dart';
import 'package:bhawsar_chemical/src/widgets/app_button_with_location.dart';
import 'package:bhawsar_chemical/src/widgets/app_dialog_loader.dart';
import 'package:bhawsar_chemical/src/widgets/app_separator_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_snackbar_toast.dart';
import 'package:bhawsar_chemical/src/widgets/app_spacer.dart';
import 'package:bhawsar_chemical/src/widgets/app_switcher_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_text.dart';
import 'package:bhawsar_chemical/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({
    super.key,
    this.orderId,
    this.distributorInfo,
    required this.productItems,
    required this.sampleItems,
    required this.popItems,
    required this.giftItems,
    required this.notInterested,
    required this.nonProductive,
    required this.distributorType,
    required this.isTimeValid,
    required this.medicalInfo,
    required this.orderNotes,
    required this.orderType,
    required this.isAddReminder,
    required this.msg,
  });

  String? orderId;
  medical.Item? distributorInfo;
  List<Map<dynamic, dynamic>> productItems;
  List<Map<dynamic, dynamic>> giftItems;
  List<Map<dynamic, dynamic>> popItems;
  List<Map<dynamic, dynamic>> sampleItems;
  bool isTimeValid = true, nonProductive = false, notInterested = false;
  final String distributorType;
  medical.Item? medicalInfo;
  final String orderNotes;
  final String orderType;
  final bool isAddReminder;
  final String msg;

  DateTime reminderDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      appBar: CustomAppBar(
        AppText(
          localization.order_summary,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 100.h <= 667 ? 17.h : 16.h,
            child: Stack(
              children: [
                Positioned(child: Container(height: 8.h, color: secondary)),
                Positioned(child: GlobalMedicalCard(medicalInfo: medicalInfo)),
              ],
            ),
          ),

          if (distributorInfo?.id != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: paddingSmall),
                minLeadingWidth: 0,
                dense: true,
                tileColor: offWhite,
                minVerticalPadding: 0,
                horizontalTitleGap: 0,
                title: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'warehouse',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      const MySeparator(),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        '${distributorInfo?.name}',
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.pin_drop, color: primary),
                          const AppSpacerWidth(),
                          Flexible(
                            child: AppText(
                              '${distributorInfo?.area}, ${distributorInfo?.city}, ${distributorInfo?.state} ',
                              fontSize: 16,
                              maxLine: 5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Divider(),
                Row(
                  children: [
                    AppText(
                      'Order Type :- ',
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                    ),
                    Flexible(
                      child: AppText(
                        orderType,
                        fontSize: 16.5,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
          AppSwitcherWidget(
            durationInMiliSec: 600,
            animationType: 'slide',
            child: productItems.isEmpty && giftItems.isEmpty && popItems.isEmpty && sampleItems.isEmpty
                ? SizedBox.shrink()
                : OrderSummaryWidget(
                    productItems: productItems,
                    giftItems: giftItems,
                    popItems: popItems,
                    sampleItems: sampleItems,
                  ),
          ),
          AppSwitcherWidget(
            durationInMiliSec: 600,
            animationType: 'slide',
            child: productItems.isEmpty && giftItems.isEmpty && popItems.isEmpty && sampleItems.isEmpty
                ? SizedBox.shrink()
                : TotalWidget(productItems: productItems),
          ),
          BlocListener<OrderBloc, OrderState>(
            listener: (context, state) async {
              if (state.status == OrderStatus.adding) {
                showAnimatedDialog(context, const AppDialogLoader());
              } else if (state.status == OrderStatus.added) {
                mySnackbar(state.msg.toString());
                Navigator.of(context).pop();
                Navigator.of(context).restorablePushReplacementNamed(RouteList.home);
              } else if (state.status == OrderStatus.failure) {
                mySnackbar(state.msg.toString(), isError: true);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingDefault),
                child: AppButtonWithLocation(
                  btnText: localization.punch_order,
                  onBtnClick: () async {
                    hideKeyboard();
                    if (distributorInfo == null && !nonProductive) {
                      mySnackbar(
                        distributorType.toLowerCase() == 'distributor'
                            ? localization.distributor_required
                            : localization.warehouse_required,
                        isError: true,
                      );
                    } else if ((isAddReminder && msg.trim().toString() == "")) {
                      mySnackbar(localization.message_required, isError: true);
                    } else if (!isTimeValid) {
                      mySnackbar(localization.time_invalid, isError: true);
                    } else if ((nonProductive && orderNotes.trim().toString() == "" && !isAddReminder)) {
                      mySnackbar(localization.special_note_required, isError: true);
                    } else {
                      List<Map<String, dynamic>> items = [];
                      List<Map<String, dynamic>> nonProductiveCall = [];

                      for (var product in productItems) {
                        if (product['add_item'] == true) {
                          items.add({
                            "product_id": product['product'].id,
                            "quantity": int.tryParse(product['qty'].toString()) ?? 1,
                            "scheme_applied": product['schemeApplied'] as bool ? 1 : 0,
                            "product_size_id": product['productSizeId'] ?? ""
                          });
                        } else {
                          nonProductiveCall.add({
                            "product_id": product['product'].id,
                            if (product['not_intrested'] != 1) "quantity": int.tryParse(product['qty'].toString()) ?? 1,
                            "not_intrested": product['not_intrested'],
                            "product_size_id": product['productSizeId'] ?? '',
                          });
                        }
                      }

                      for (var gift in giftItems) {
                        items.add({
                          "product_id": gift['gift'].id,
                          "quantity": gift['qty'],
                          "product_size_id": gift['size_id'] ?? '',
                        });
                      }
                      for (var pop in popItems) {
                        items.add({
                          "product_id": pop['pop'].id,
                          "quantity": pop['qty'],
                          "product_size_id": pop['size_id'] ?? '',
                        });
                      }
                      for (var sample in sampleItems) {
                        items.add({
                          "product_id": sample['sample'].id,
                          "quantity": sample['qty'],
                          "product_size_id": sample['size_id'] ?? '',
                        });
                      }

                      Map<String, dynamic> formData1 = {};
                      if (orderId == null) {
                        formData1 = {
                          "_method": "POST",
                          "order": {
                            "client_id": medicalInfo?.id,
                            "distributor": distributorInfo?.id,
                            "notes": orderNotes,
                            "non_productive": nonProductive ? 1 : 0,
                            "type": orderType,
                            if (isAddReminder)
                              "reminder": {
                                "message": msg,
                                "date_time": '${getDate(reminderDate.toString())} ${getHMS(selectedTime)}',
                              },
                            "items": items,
                            if (nonProductiveCall.isNotEmpty) "not_intrested_items": nonProductiveCall,
                            if (nonProductiveCall.isEmpty) "not_intrested": 1
                          }
                        };
                        context.read<OrderBloc>().add(
                              AddOrderEvent(
                                formData: formData1,
                                reqType: 'post',
                              ),
                            );
                      } else {
                        formData1 = {
                          "_method": "PUT",
                          "order": {
                            "order_id": orderId,
                            "client_id": medicalInfo?.id,
                            "distributor": distributorInfo?.id,
                            "notes": orderNotes,
                            "non_productive": nonProductive,
                            "lat": 0.0,
                            "lng": 0.0,
                            "type": orderType,
                            if (isAddReminder)
                              "reminder": {
                                "message": msg,
                                "date_time": '${getDate(reminderDate.toString())} ${getHMS(selectedTime)}',
                              },
                            "items": items,
                            "not_intrested_items": nonProductiveCall,
                          }
                        };
                        context.read<OrderBloc>().add(
                              AddOrderEvent(
                                formData: formData1,
                                reqType: 'PUT',
                              ),
                            );
                      }
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
