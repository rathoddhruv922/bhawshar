import 'package:bhawsar_chemical/data/models/medical_model/item.dart' as medical;
import 'package:bhawsar_chemical/data/models/order_model/distributor.dart';
import 'package:bhawsar_chemical/data/models/order_model/product.dart' as order_product;
import 'package:bhawsar_chemical/src/router/route_list.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/cart_item_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_switcher_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/order/order_bloc.dart';
import '../../../../business_logic/bloc/product/product_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../constants/enums.dart';
import '../../../../data/models/order_model/order_model.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_animated_dialog.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_button_with_location.dart';
import '../../../widgets/app_dialog_loader.dart';
import '../../../widgets/app_picker.dart';
import '../../../widgets/app_snackbar_toast.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_medical_card_widget.dart';
import '../../common/common_order_type_widget.dart';
import '../../common/common_reminder_note_widget.dart';
import '../../common/common_static_reminder_day.dart';
import '../../common/common_time_picker_widget.dart';
import '../add_order/widget/distributor_tile_widget.dart';
import '../add_order/widget/expansion_panel_header_widget.dart';
import '../add_order/widget/order_notes_textfield_widget.dart';
import '../add_order/widget/product_search_widget.dart';
import '../add_order/widget/reminder_note_textfield_widget.dart';
import '../add_order/widget/search_item_widget.dart';

class UpdateOrderScreen extends StatefulWidget {
  const UpdateOrderScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<UpdateOrderScreen> createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchProductController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController distributorController = TextEditingController();

  TextEditingController msgController = TextEditingController();
  TextEditingController orderNotesController = TextEditingController();

  List<Map<dynamic, dynamic>> productItems = [];
  List<Map<dynamic, dynamic>> giftItems = [];
  List<Map<dynamic, dynamic>> popItems = [];
  List<Map<dynamic, dynamic>> sampleItems = [];
  DateTime reminderDate = DateTime.now();
  String? reminderDays;
  TimeOfDay selectedTime = TimeOfDay.now();
  Distributor? distributorInfo;
  String? orderType = 'At Shop';

  Map<String, dynamic> formData = {};
  String? distributorType;
  OrderModel? order;
  bool isAddReminder = false, isLoading = true, nonProductive = false, notInterested = true;
  int reminderComplete = 0;
  bool isTimeValid = true;
  bool removeStaticDate = false; // used for unselect static date

  List<int> data = [0, 1, 2, 3];

  @override
  void initState() {
    context.read<OrderBloc>().add(GetOrderEvent(orderId: widget.orderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        Navigator.pop(context, true);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: white,
        appBar: CustomAppBar(
          AppText(
            localization.order_update,
            color: primary,
            fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              // await appAlertDialog(
              //     context,
              //     AppText(
              //       S.of(context).confirmation,
              //       textAlign: TextAlign.center,
              //       fontSize: 17,
              //     ), () {
              //   Navigator.of(context).pop(true);
              //   Navigator.of(context).pop(true);
              // }, () {
              //   Navigator.of(context).pop();
              // });
            },
            icon: getBackArrow(),
            color: primary,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocListener<OrderBloc, OrderState>(
                  listenWhen: ((previous, current) {
                    if (previous.status == OrderStatus.updating) {
                      return false;
                    }
                    return true;
                  }),
                  listener: (context, state) async {
                    if (state.status == OrderStatus.load) {
                      setState(() {
                        try {
                          order = state.res;
                        } catch (e) {
                          showCatchedError(e);
                        }
                        if (order?.order?.id != null) {
                          try {
                            distributorInfo = order?.order?.distributor;
                            distributorController.clear();
                          } catch (e) {
                            showCatchedError(e);
                          }
                          try {
                            if (order?.order?.client?.type?.toLowerCase() == 'medical' ||
                                order?.order?.client?.type?.toLowerCase() == 'doctor') {
                              distributorType = 'distributor';
                            } else if (order?.order?.client?.type?.toLowerCase() == 'distributor') {
                              distributorType = 'warehouse';
                            } else {
                              myToastMsg("We can't not place order for this client!", isError: true);
                            }
                          } catch (e) {
                            showCatchedError(e);
                          }
                          try {
                            if (order?.order?.reminder?.id != null) {
                              isAddReminder = true;
                              if (order?.order?.reminder?.deletedAt != "") {
                                reminderComplete = 1;
                              } else {
                                reminderComplete = (order?.order?.reminder?.complete) ?? 0;
                              }
                              reminderDate = DateTime.parse((order?.order?.reminder?.dateTime).toString());
                              selectedTime = getTimeOfFromDateTime((order?.order?.reminder?.dateTime).toString());
                              msgController.text = (order?.order?.reminder?.message).toString();
                            }
                          } catch (e) {
                            showCatchedError(e);
                          }
                          orderType = order?.order?.type;
                          nonProductive = order?.order?.status == 'ZeroSum' ? true : false;
                          orderNotesController.text = (order?.order?.notes).toString();
                          data = (order?.order?.notIntrested == 1) ? [1, 2, 3] : [0, 1, 2, 3];
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
                                  'gift': element.product as order_product.Product,
                                  'price': double.parse(currencyFormat.format(element.price)),
                                  'qty': element.quantity,
                                  'size': element.size,
                                  'size_id': element.productSizeId,
                                  'scheme': element.scheme,
                                });
                              } else if (element.productType?.toLowerCase() == 'pop material') {
                                popItems.add({
                                  'pop': element.product,
                                  'price': double.parse(currencyFormat.format(element.price)),
                                  'qty': element.quantity,
                                  'size': element.size,
                                  'size_id': element.productSizeId,
                                  'scheme': element.scheme,
                                });
                              } else if (element.productType?.toLowerCase() == 'free sample') {
                                sampleItems.add({
                                  'sample': element.product,
                                  'price': double.parse(currencyFormat.format(element.price)),
                                  'qty': element.quantity,
                                  'size': element.size,
                                  'size_id': element.productSizeId,
                                  'scheme': element.scheme,
                                });
                              }
                            });

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
                      setState(() {
                        isLoading = false;
                      });
                    }
                    if (state.status == OrderStatus.failure) {
                      mySnackbar(state.msg.toString(), isError: true);
                      await Future.delayed(Duration.zero);
                      Navigator.of(context).pop();
                    }
                  },
                  child: isLoading
                      ? const SizedBox.shrink()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 100.h <= 667 ? 17.h : 16.h,
                              child: Stack(
                                children: [
                                  Positioned(child: Container(height: 8.h, color: secondary)),
                                  Positioned(child: GlobalMedicalCard(dynamicMedicalInfo: order?.order)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: paddingDefault, horizontal: paddingDefault + 5),
                              child: StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return OrderTypeWidget(
                                    type: orderType,
                                    onChanged: ((value) {
                                      setState(() {
                                        orderType = value;
                                      });
                                    }),
                                  );
                                },
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.only(left: 16, right: 16, bottom: nonProductive ? 0 : paddingDefault),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: paddingLarge,
                                ),
                                tileColor: greyLight,
                                dense: true,
                                title: AppText(
                                  localization.non_productive_call,
                                  color: grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                onTap: null,
                                trailing: Icon(
                                  nonProductive ? Icons.check_box : Icons.check_box_outline_blank_outlined,
                                  color: grey,
                                ),
                              ),
                            ),
                            AppSwitcherWidget(
                              durationInMiliSec: 600,
                              animationType: 'slide',
                              child: nonProductive
                                  ? SizedBox.shrink()
                                  : DistributorTile(
                                      distributorController: distributorController,
                                      distributorInfo: distributorInfo,
                                      distributorType: distributorType,
                                      onDistributorChanged: ((value) {
                                        setState(() {
                                          distributorInfo = value;
                                          distributorController.clear();
                                        });
                                      }),
                                    ),
                            ),
                            AppSwitcherWidget(
                              durationInMiliSec: 600,
                              animationType: 'slide',
                              child: _buildPanel(data),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: paddingExtraSmall),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: paddingDefault),
                                    child: ListTile(
                                      dense: true,
                                      tileColor: secondary,
                                      minLeadingWidth: 0,
                                      minVerticalPadding: 0,
                                      contentPadding:
                                          const EdgeInsets.symmetric(vertical: paddingSmall, horizontal: paddingDefault + 3),
                                      title: AppText(
                                        localization.special_note,
                                        color: textBlack,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(
                                          top: paddingSmall,
                                          bottom: paddingExtraSmall,
                                        ),
                                        child: OrderNotesTextFieldWidget(orderNotesController: orderNotesController),
                                      ),
                                    ),
                                  ),
                                  _reminderWidget(),
                                  AppSwitcherWidget(
                                    durationInMiliSec: 600,
                                    animationType: 'slide',
                                    child: (productItems.isEmpty && giftItems.isEmpty && popItems.isEmpty && sampleItems.isEmpty)
                                        ? SizedBox.shrink()
                                        : const Divider(
                                            color: greyLight,
                                            thickness: 4,
                                          ),
                                  ),
                                  !nonProductive &&
                                          (productItems.isEmpty && giftItems.isEmpty && popItems.isEmpty && sampleItems.isEmpty)
                                      ? SizedBox.shrink()
                                      : BlocListener<OrderBloc, OrderState>(
                                          listener: (context, state) async {
                                            if (state.status == OrderStatus.failure) {
                                              mySnackbar(state.msg.toString(), isError: true);
                                            }
                                            if (state.status == OrderStatus.updating) {
                                              showAnimatedDialog(context, const AppDialogLoader());
                                            }
                                            if (state.status == OrderStatus.updated) {
                                              Navigator.of(context).pop(true);
                                              mySnackbar(state.msg.toString());
                                              if (Navigator.of(context).canPop() == true) {
                                                Navigator.of(context).pop(true);
                                              }
                                            }
                                          },
                                          child: SafeArea(
                                            top: false,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: paddingDefault),
                                                child: AppButtonWithLocation(
                                                  btnText: localization.order_update,
                                                  onBtnClick: () {
                                                    hideKeyboard();
                                                    if (distributorInfo == null && !nonProductive) {
                                                      mySnackbar(
                                                        distributorType?.toLowerCase() == 'distributor'
                                                            ? localization.distributor_required
                                                            : localization.warehouse_required,
                                                        isError: true,
                                                      );
                                                    } else if ((isAddReminder && msgController.text.trim().toString() == "")) {
                                                      mySnackbar(localization.message_required, isError: true);
                                                    } else if (!isTimeValid) {
                                                      mySnackbar(localization.time_invalid, isError: true);
                                                    } else if ((nonProductive &&
                                                        orderNotesController.text.trim().toString() == "" &&
                                                        !isAddReminder)) {
                                                      mySnackbar(localization.special_note_required, isError: true);
                                                    } else {
                                                      for (var item in productItems) {
                                                        if (item["not_intrested"] == 0 &&
                                                            (item["qty"] == "" || item["qty"] == null)) {
                                                          mySnackbar("Quantity is missing");
                                                          return;
                                                        }
                                                      }
                                                      medical.Item medicalInfo = medical.Item(
                                                        id: order?.order?.client?.id,
                                                        email: order?.order?.client?.email,
                                                        address: order?.order?.client?.address,
                                                        image: order?.order?.client?.image,
                                                        status: order?.order?.client?.status,
                                                        city: order?.order?.client?.city,
                                                        name: order?.order?.client?.name,
                                                        state: order?.order?.client?.state,
                                                        area: order?.order?.client?.area,
                                                        areaId: order?.order?.client?.areaId,
                                                        cityId: order?.order?.client?.cityId,
                                                        createdBy: order?.order?.client?.createdBy,
                                                        mobile: order?.order?.client?.mobile,
                                                        zip: order?.order?.client?.zip,
                                                        notification: order?.order?.client?.notification,
                                                        panGst: order?.order?.client?.panGst,
                                                        panGstType: order?.order?.client?.panGstType,
                                                        phone: order?.order?.client?.phone,
                                                        profile: order?.order?.client?.profile,
                                                        stateId: order?.order?.client?.stateId,
                                                        type: order?.order?.client?.type,
                                                      );

                                                      medical.Item distributor = medical.Item(
                                                        id: distributorInfo?.id,
                                                        email: distributorInfo?.email,
                                                        address: distributorInfo?.address,
                                                        image: distributorInfo?.image,
                                                        status: distributorInfo?.status,
                                                        city: distributorInfo?.city,
                                                        name: distributorInfo?.name,
                                                        state: distributorInfo?.state,
                                                        area: distributorInfo?.area,
                                                        areaId: distributorInfo?.areaId,
                                                        cityId: distributorInfo?.cityId,
                                                        createdBy: distributorInfo?.createdBy,
                                                        mobile: distributorInfo?.mobile,
                                                        zip: distributorInfo?.zip,
                                                        notification: distributorInfo?.notification,
                                                        panGst: distributorInfo?.panGst,
                                                        panGstType: distributorInfo?.panGstType,
                                                        phone: distributorInfo?.phone,
                                                        profile: distributorInfo?.profile,
                                                        stateId: distributorInfo?.stateId,
                                                        type: distributorInfo?.type,
                                                      );

                                                      navigationKey.currentState!.pushNamed(
                                                        RouteList.checkout,
                                                        arguments: {
                                                          "orderID": widget.orderId.toString(),
                                                          "popItems": popItems,
                                                          "distributorType": distributorType,
                                                          "giftItems": giftItems,
                                                          "isAddReminder": isAddReminder,
                                                          "isTimeValid": isTimeValid,
                                                          "medicalInfo": medicalInfo,
                                                          "msg": msgController.text.trim().toString(),
                                                          "nonProductive": nonProductive,
                                                          "notInterested": false,
                                                          "orderNotes": orderNotesController.text.toString(),
                                                          "orderType": orderType.toString(),
                                                          "productItems": productItems,
                                                          "sampleItems": sampleItems,
                                                          "distributorInfo": distributor,
                                                        },
                                                      );
                                                    }
                                                    // hideKeyboard();
                                                    // if (distributorInfo == null && !nonProductive) {
                                                    //   mySnackbar(
                                                    //       distributorType?.toLowerCase() == 'distributor'
                                                    //           ? localization.distributor_required
                                                    //           : localization.warehouse_required,
                                                    //       isError: true);
                                                    //   return;
                                                    // }
                                                    // if ((isAddReminder && msgController.text.trim().toString() == "")) {
                                                    //   mySnackbar(localization.message_required, isError: true);
                                                    //   return;
                                                    // }
                                                    // if (!isTimeValid) {
                                                    //   mySnackbar(localization.time_invalid, isError: true);
                                                    // } else if ((nonProductive &&
                                                    //     orderNotesController.text.trim().toString() == "")) {
                                                    //   mySnackbar(localization.special_note_required, isError: true);
                                                    // } else {
                                                    //   List<Map<String, dynamic>> items = [];
                                                    //   for (var product in productItems) {
                                                    //     items.add({
                                                    //       "product_id": product['product'].id,
                                                    //       "quantity": product['qty'],
                                                    //       "product_size_id": product['size_id'] ?? '',
                                                    //       "scheme_applied": product['schemeApplied']
                                                    //     });
                                                    //   }
                                                    //   for (var gift in giftItems) {
                                                    //     items.add({
                                                    //       "product_id": gift['gift'].id,
                                                    //       "quantity": gift['qty'],
                                                    //       "product_size_id": gift['size_id'] ?? '',
                                                    //     });
                                                    //   }
                                                    //   for (var pop in popItems) {
                                                    //     items.add({
                                                    //       "product_id": pop['pop'].id,
                                                    //       "quantity": pop['qty'],
                                                    //       "product_size_id": pop['size_id'] ?? '',
                                                    //     });
                                                    //   }
                                                    //   for (var sample in sampleItems) {
                                                    //     items.add({
                                                    //       "product_id": sample['sample'].id,
                                                    //       "quantity": sample['qty'],
                                                    //       "product_size_id": sample['size_id'] ?? '',
                                                    //     });
                                                    //   }
                                                    //
                                                    //   Map<String, dynamic> formData = isAddReminder
                                                    //       ? {
                                                    //           "_method": "PUT",
                                                    //           "non_productive": nonProductive ? 1 : 0,
                                                    //           "order_id": order?.order?.id,
                                                    //           "client_id": order?.order?.client?.id,
                                                    //           "distributor": distributorInfo?.id,
                                                    //           "notes": orderNotesController.text,
                                                    //           "type": orderType,
                                                    //           "reminder": {
                                                    //             "message": msgController.text,
                                                    //             "date_time":
                                                    //                 '${getDate(reminderDate.toString())} ${getHMS(selectedTime)}',
                                                    //           },
                                                    //           "items": items
                                                    //         }
                                                    //       : {
                                                    //           "_method": "PUT",
                                                    //           "non_productive": nonProductive ? 1 : 0,
                                                    //           "order_id": order?.order?.id,
                                                    //           "client_id": order?.order?.client?.id,
                                                    //           "distributor": distributorInfo?.id,
                                                    //           "notes": orderNotesController.text,
                                                    //           "type": orderType,
                                                    //           "items": items
                                                    //         };
                                                    //   context.read<OrderBloc>().add(
                                                    //         AddOrderEvent(
                                                    //           formData: formData,
                                                    //           reqType: 'put',
                                                    //         ),
                                                    //       );
                                                    // }
                                                    // // }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPanel(data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: paddingExtraSmall + paddingDefault, vertical: paddingDefault),
      child: ExpansionPanelList.radio(
        animationDuration: const Duration(milliseconds: 600),
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: ((panelIndex, isExpanded) async {
          searchProductController.clear();
          context.read<ProductBloc>().add(const ClearProductEvent());
        }),
        children: data.map<ExpansionPanelRadio>((int headerItem) {
          return ExpansionPanelRadio(
            value: headerItem,
            backgroundColor: secondary,
            headerBuilder: (BuildContext context, bool isExpanded) {
              if (isExpanded) {
                List<int> existingProductIds = [];
                if (headerItem == 0) {
                  for (var item in productItems) {
                    if (item['product'].configurable == 0) {
                      existingProductIds.add(item['product'].id);
                    }
                  }
                } else if (headerItem == 1) {
                  for (var item in giftItems) {
                    existingProductIds.add(item['gift'].id);
                  }
                } else if (headerItem == 2) {
                  for (var item in popItems) {
                    existingProductIds.add(item['pop'].id);
                  }
                } else {
                  for (var item in sampleItems) {
                    existingProductIds.add(item['sample'].id);
                  }
                }

                BlocProvider.of<ProductBloc>(context).add(GetProductsEvent(
                  type: headerItem == 0
                      ? 'product'
                      : headerItem == 1
                          ? 'gift article'
                          : headerItem == 2
                              ? 'pop material'
                              : 'free sample',
                  existingProductIds: existingProductIds,
                ));
              } else {
                context.read<ProductBloc>().add(const ClearProductEvent());
              }

              return ExpansionPanelHeaderWidget(
                  headerItem: headerItem,
                  productItems: productItems,
                  giftItems: giftItems,
                  popItems: popItems,
                  sampleItems: sampleItems);
              /*  return ExpansionPanelHeaderWidget(
                  headerItem: headerItem,
                  productItems: productItems,
                  giftItems: giftItems,
                  popItems: popItems,
                  sampleItems: sampleItems);*/
            },
            body: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: paddingDefault),
              tileColor: white,
              dense: true,
              horizontalTitleGap: 0,
              isThreeLine: true,
              title: ProductSearchWidget(
                  headerItem: headerItem,
                  searchProductController: searchProductController,
                  productItems: productItems,
                  giftItems: giftItems,
                  popItems: popItems,
                  sampleItems: sampleItems),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingDefault),
                child: Column(
                  children: [
                    SearchItemWidget(
                      onChanged: (updateWidget) {
                        if (updateWidget) {
                          setState(() {
                            searchProductController.clear();
                          });
                        }
                      },
                      nonProductive: nonProductive,
                      headerItem: headerItem,
                      productItems: productItems,
                      giftItems: giftItems,
                      popItems: popItems,
                      sampleItems: sampleItems,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 35.0,
                      ),
                      child: CartItemWidget(
                        onChanged: (updateWidget) {
                          setState(() {});
                        },
                        id: headerItem,
                        productItems: [],
                        giftItems: giftItems,
                        popItems: popItems,
                        sampleItems: sampleItems,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _reminderWidget() {
    final GlobalKey<FormState> orderReminderFormKey = GlobalKey<FormState>();
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Form(
          key: orderReminderFormKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: AbsorbPointer(
            absorbing: reminderComplete == 1 ? true : false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingDefault, vertical: 10),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: transparent,
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: paddingLarge),
                  childrenPadding: const EdgeInsets.symmetric(vertical: paddingSmall, horizontal: paddingDefault * 2),
                  title: AppText(
                    (order?.order?.reminder?.clientId == null) ? localization.reminder_add : localization.reminder_update,
                    color: textBlack,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: reminderComplete == 1
                      ? AppText(
                          localization.reminder_edit_warning,
                          fontWeight: FontWeight.bold,
                          color: yellow,
                        )
                      : null,
                  onExpansionChanged: ((value) {
                    setState(() {
                      isAddReminder = value;
                    });
                  }),
                  trailing: Icon(isAddReminder ? Icons.check_box : Icons.check_box_outline_blank_outlined),
                  controlAffinity: ListTileControlAffinity.trailing,
                  initiallyExpanded: isAddReminder,
                  backgroundColor: offWhite,
                  collapsedBackgroundColor: secondary,
                  children: <Widget>[
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        reminderComplete == 0 ? transparent : grey.withOpacity(0.1),
                        BlendMode.srcATop,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonStaticReminderDay(
                            onDayChanged: ((value) {
                              setState(() {
                                removeStaticDate = false;
                                reminderDate = value;
                                reminderDays = daysBetween(DateTime.now(), value);
                              });
                            }),
                            removeStaticDate: removeStaticDate,
                          ),
                          const AppSpacerHeight(height: 15),
                          CustomDatePicker(
                            minDate: DateTime.now(),
                            expiredTime: reminderDate.isBefore(DateTime.now()) ? reminderDate : DateTime.now(),
                            date: reminderDate.isBefore(DateTime.now()) ? DateTime.now() : reminderDate,
                            title: localization.select_reminder_date,
                            onChanged: ((DateTime value) {
                              setState(() {
                                removeStaticDate = true;
                                reminderDate = value;
                                DateTime temp = DateTime.parse('${getDate(reminderDate.toString())} ${getHMS(selectedTime)}');
                                if (temp.compareTo(DateTime.now()).isNegative) {
                                  setState(() {
                                    isTimeValid = false;
                                    reminderDays ??= 'Today,';
                                  });
                                } else {
                                  isTimeValid = true;
                                  reminderDays = daysBetween(DateTime.now(), value);
                                }
                              });
                            }),
                          ),
                          const AppSpacerHeight(height: 15),
                          CommonTimePickerWidget(
                              selectedTime: selectedTime,
                              onTimeChanged: (value) {
                                setState(() {
                                  selectedTime = value;
                                  DateTime temp = DateTime.parse('${getDate(reminderDate.toString())} ${getHMS(selectedTime)}');
                                  if (temp.compareTo(DateTime.now()).isNegative) {
                                    setState(() {
                                      isTimeValid = false;
                                      reminderDays ??= 'Today,';
                                    });
                                  } else {
                                    isTimeValid = true;
                                    reminderDays = daysBetween(DateTime.now(), reminderDate);
                                  }
                                });
                              }),
                          ReminderNotesWidget(
                              reminderDays: reminderDays, isTimeValid: isTimeValid, context: context, selectedTime: selectedTime),
                          AppSpacerHeight(height: reminderDays == null ? 15 : 0),
                          ReminderNoteTextFieldWidget(
                              msgController: msgController, formKey: isAddReminder ? orderReminderFormKey : null),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
