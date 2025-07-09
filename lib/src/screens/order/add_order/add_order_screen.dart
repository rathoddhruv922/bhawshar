import 'package:bhawsar_chemical/data/models/medical_model/item.dart' as medical;
import 'package:bhawsar_chemical/src/router/route_list.dart';
import 'package:bhawsar_chemical/src/screens/common/common_order_type_widget.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/cart_item_widget.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/distributor_tile_widget.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/expansion_panel_header_widget.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/order_notes_textfield_widget.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/product_search_widget.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/reminder_note_textfield_widget.dart';
import 'package:bhawsar_chemical/src/screens/order/add_order/widget/search_item_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_switcher_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/order/order_bloc.dart';
import '../../../../business_logic/bloc/product/product_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../constants/enums.dart';
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
import '../../common/common_reminder_note_widget.dart';
import '../../common/common_static_reminder_day.dart';
import '../../common/common_time_picker_widget.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key, required this.medicalInfo});

  final medical.Item medicalInfo;

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchProductController = TextEditingController();
  final TextEditingController distributorController = TextEditingController();

  TextEditingController msgController = TextEditingController();
  TextEditingController orderNotesController = TextEditingController();

  List<Map<dynamic, dynamic>> productItems = [];
  List<Map<dynamic, dynamic>> giftItems = [];
  List<Map<dynamic, dynamic>> popItems = [];
  List<Map<dynamic, dynamic>> sampleItems = [];
  DateTime reminderDate = DateTime.now();
  String? reminderDays;

  bool isTimeValid = true, nonProductive = false, notInterested = false;

  medical.Item? distributorInfo;
  String? orderType = 'At Shop';

  Map<String, dynamic> formData = {};
  TimeOfDay selectedTime = TimeOfDay.now();
  final List<int> reminder = [0];
  String? distributorType;
  bool isAddReminder = false;
  bool removeStaticDate = false; // used for unselect static date
  List<int> data = [0, 1, 2, 3];

  @override
  void initState() {
    if (widget.medicalInfo.type!.toLowerCase() == 'medical' || widget.medicalInfo.type!.toLowerCase() == 'doctor') {
      distributorType = 'distributor';
    } else if (widget.medicalInfo.type!.toLowerCase() == 'distributor') {
      distributorType = 'warehouse';
    } else {
      Navigator.of(context).pop();
      myToastMsg("We can't not place order for this client!", isError: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      appBar: CustomAppBar(
        AppText(
          localization.order_add,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context).pop();
            // await appAlertDialog(
            //     context,
            //     AppText(
            //       S.of(context).confirmation,
            //       textAlign: TextAlign.center,
            //       fontSize: 17,
            //     ), () {
            //   Navigator.of(context).pop();
            //   Navigator.of(context).pop();
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
              SizedBox(
                height: 100.h <= 667 ? 17.h : 16.h,
                child: Stack(
                  children: [
                    Positioned(child: Container(height: 8.h, color: secondary)),
                    Positioned(child: GlobalMedicalCard(medicalInfo: widget.medicalInfo)),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: paddingLarge),
                  tileColor: secondary,
                  dense: true,
                  title: AppText(
                    localization.non_productive_call,
                    color: textBlack,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () {
                    nonProductive = !nonProductive;
                    notInterested = false;
                    productItems = [];
                    giftItems = [];
                    popItems = [];
                    sampleItems = [];
                    data = nonProductive ? [0, 1, 2, 3] : [0, 1, 2, 3];
                    setState(() {});
                  },
                  trailing: Icon(
                    nonProductive ? Icons.check_box : Icons.check_box_outline_blank_outlined,
                    color: nonProductive ? primary : grey,
                  ),
                ),
              ),
              if (nonProductive)
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: paddingDefault),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText(
                          localization.not_interested_in_any_product,
                          color: textBlack,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Switch.adaptive(
                        value: notInterested,
                        activeTrackColor: Colors.green,
                        inactiveTrackColor: grey,
                        onChanged: (value) {
                          setState(() {
                            notInterested = value;
                            productItems = [];
                          });
                        },
                      )
                    ],
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
                        contentPadding: const EdgeInsets.symmetric(vertical: paddingSmall, horizontal: paddingDefault + 3),
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
                    BlocListener<OrderBloc, OrderState>(
                      listener: (context, state) async {
                        if (state.status == OrderStatus.adding) {
                          showAnimatedDialog(navigationKey.currentContext!, const AppDialogLoader());
                        } else if (state.status == OrderStatus.added) {
                          Navigator.of(context).pop();
                          mySnackbar(state.msg.toString());
                          if (Navigator.of(context).canPop() == true) {
                            Navigator.of(context).pop(true);
                          }
                        } else if (state.status == OrderStatus.failure) {
                          mySnackbar(state.msg.toString(), isError: true);
                          await Future.delayed(Duration.zero);
                          if (!mounted) {
                            return;
                          }
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
                                  distributorType?.toLowerCase() == 'distributor'
                                      ? localization.distributor_required
                                      : localization.warehouse_required,
                                  isError: true,
                                );
                              } else if ((isAddReminder && msgController.text.trim().toString() == "")) {
                                mySnackbar(localization.message_required, isError: true);
                              } else if (!isTimeValid) {
                                mySnackbar(localization.time_invalid, isError: true);
                              } else if ((nonProductive && orderNotesController.text.trim().toString() == "" && !isAddReminder)) {
                                mySnackbar(localization.special_note_required, isError: true);
                              } else if (productItems.isEmpty && !notInterested) {
                                mySnackbar("Product is empty", isError: true);
                              } else {
                                for (var item in productItems) {
                                  if (item["not_intrested"] == 0 &&
                                      (item["qty"] == "" || item["qty"] == null || item["qty"] == "0")) {
                                    mySnackbar("Quantity is missing in ${item["product"].name} ${item["size"]}");
                                    return;
                                  }
                                }
                                navigationKey.currentState!.pushNamed(
                                  RouteList.checkout,
                                  arguments: {
                                    "popItems": popItems,
                                    "distributorType": distributorType,
                                    "giftItems": giftItems,
                                    "isAddReminder": isAddReminder,
                                    "isTimeValid": isTimeValid,
                                    "medicalInfo": widget.medicalInfo,
                                    "msg": msgController.text.trim().toString(),
                                    "nonProductive": nonProductive,
                                    "notInterested": notInterested,
                                    "orderNotes": orderNotesController.text.toString(),
                                    "orderType": orderType.toString(),
                                    "productItems": productItems,
                                    "sampleItems": sampleItems,
                                    "distributorInfo": distributorInfo,
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
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
        children: data.where((int headerItem) => headerItem != 0 || !notInterested).map<ExpansionPanelRadio>((int headerItem) {
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
              /*return ExpansionPanelHeaderWidget(
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
                  localization.reminder_add,
                  color: textBlack,
                  fontWeight: FontWeight.bold,
                ),
                onExpansionChanged: ((value) {
                  setState(() {
                    isAddReminder = value;
                  });
                }),
                trailing: Icon(isAddReminder ? Icons.check_box : Icons.check_box_outline_blank_outlined),
                controlAffinity: ListTileControlAffinity.trailing,
                initiallyExpanded: false,
                backgroundColor: offWhite,
                collapsedBackgroundColor: secondary,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonStaticReminderDay(
                        onDayChanged: ((value) {
                          setState(() {
                            removeStaticDate = false;
                            isTimeValid = true;
                            reminderDate = value;
                            reminderDays = daysBetween(DateTime.now(), value);
                          });
                        }),
                        removeStaticDate: removeStaticDate,
                      ),
                      const AppSpacerHeight(height: 15),
                      CustomDatePicker(
                        minDate: DateTime.now(),
                        date: reminderDate.add(const Duration(hours: 1)),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
