// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';

import 'package:bhawsar_chemical/business_logic/bloc/from-area/from_area_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/to-area/to_area_bloc.dart';
import 'package:bhawsar_chemical/data/models/expenses_model/item.dart'
as expense;
import 'package:bhawsar_chemical/src/widgets/app_loader_simple.dart';
import 'package:bhawsar_chemical/src/widgets/app_text_field.dart';
import 'package:bhawsar_chemical/utils/form_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/expense/expense_bloc.dart';
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
import '../../../widgets/app_switcher_widget.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_file_picker_widget.dart';
import '../widget/amount_textfield_widget.dart';
import '../widget/da_type_widget.dart';
import '../widget/expense_type_widget.dart';
import '../widget/misc_other_sub_type_widget.dart';
import '../widget/note_textfield_widget.dart';
import '../widget/travel_type_widget.dart';

class UpdateExpenseScreen extends StatelessWidget {
  final expense.Item expenseInfo;
  final int id;

  const UpdateExpenseScreen({super.key, required this.expenseInfo, required this.id});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    String? reqType = 'put';
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Navigator.pop(context, true);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: offWhite,
        appBar: CustomAppBar(
          AppText(
            localization.update_expense,
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
        body: BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) async {
            if (state.status == ExpenseStatus.updating) {
              showAnimatedDialog(context, const AppDialogLoader());
            }
            if (state.status == ExpenseStatus.updated) {
              Navigator.pop(context); // for close Loader
              mySnackbar(state.msg.toString());
              await Future.delayed(const Duration(milliseconds: 500));
              Navigator.of(context).pop(true);
            }
            if (state.status == ExpenseStatus.failure) {
              Navigator.of(context).pop();
              mySnackbar(state.msg.toString(), isError: state.status == ExpenseStatus.failure ? true : false);

              await Future.delayed(const Duration(seconds: 1));
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(paddingDefault),
            physics: const AlwaysScrollableScrollPhysics(),
            child: UpdateExpenseFormWidget(
              reqType: reqType,
              expenseId: id,
              expenseInfo: expenseInfo,
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateExpenseFormWidget extends StatelessWidget {
  final String reqType;
  final expense.Item expenseInfo;
  final int? expenseId;

  const UpdateExpenseFormWidget({Key? key, required this.reqType, required this.expenseInfo, required this.expenseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> amountFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> messageFormKey = GlobalKey<FormState>();
    Map<String, dynamic> formData = {};
    TextEditingController expenseNoteController = TextEditingController();
    TextEditingController expenseAmountController = TextEditingController();
    final GlobalKey<FormState> placedWorkedFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> distanceFormKey = GlobalKey<FormState>();

    TextEditingController fromAreaController = TextEditingController();
    TextEditingController toAreaController = TextEditingController();
    TextEditingController placedWorkedController = TextEditingController();
    TextEditingController distanceController = TextEditingController();
    final GlobalKey<FormState> fromFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> toFormKey = GlobalKey<FormState>();
    Timer? debounce;
    int? fromAreaId, toAreaId;
    late String expenseType;
    late String? subType, lastSearchKeyword;
    late DateTime expenseDate;
    List<PlatformFile> paths = [];
    List<int> deletedFileId = [];

    expenseNoteController.text = expenseInfo.note.toString();
    expenseAmountController.text = expenseInfo.amount.toString();
    expenseType = expenseInfo.type.toString();
    subType = expenseInfo.subType.toString();
    fromAreaId = expenseInfo.fromArea?.id ?? -1;
    fromAreaController.text = expenseInfo.fromArea?.name ?? '';
    toAreaController.text = expenseInfo.toArea?.name ?? '';
    placedWorkedController.text = expenseInfo.placesWorked ?? '';
    distanceController.text = expenseInfo.distance?.toString() ?? '';
    toAreaId = expenseInfo.toArea?.id ?? -1;
    expenseDate = DateTime.parse(expenseInfo.expenseDate.toString());

    onFromAreaSearchChanged() async {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 700), () {
        if (fromAreaController.text.trim() != "" && lastSearchKeyword != fromAreaController.text.trim()) {
          lastSearchKeyword = fromAreaController.text.trim();
          BlocProvider.of<FromAreaBloc>(context).add(
            GetFromAreaListEvent(
              searchKeyword: fromAreaController.text.trim(),
            ),
          );
        } else {
          fromAreaId = null;
        }
      });
    }

    onToAreaSearchChanged() async {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 700), () {
        if (toAreaController.text.trim() != "" && lastSearchKeyword != toAreaController.text.trim()) {
          lastSearchKeyword = toAreaController.text.trim();
          BlocProvider.of<ToAreaBloc>(context).add(
            GetToAreaListEvent(
              searchKeyword: toAreaController.text.trim(),
            ),
          );
        } else {
          toAreaId = null;
        }
      });
    }

    return SafeArea(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Form(
                              key: fromFormKey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: AppTextField(
                                textEditingController: fromAreaController,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: primary,
                                ),
                                labelText: localization.from_area,
                                hintText: localization.from_area_enter,
                                textInputAction: TextInputAction.search,
                                onChanged: (value) {
                                  if (value != '') {
                                    onFromAreaSearchChanged();
                                  }
                                },
                                onFieldSubmit: (value) {
                                  if (value != null && value.trim() != '') {
                                    onFromAreaSearchChanged();
                                  }
                                },
                                formValidator: (value) {
                                  return FormValidate.requiredField(value!, localization.from_area_required);
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            child: BlocBuilder<FromAreaBloc, FromAreaState>(
                              builder: (context, state) {
                                return AppSwitcherWidget(
                                  animationType: 'slide',
                                  child: state.status == AreaStatus.loading
                                      ? const Padding(padding: EdgeInsets.only(top: paddingSmall), child: AppLoader())
                                      : state.status == AreaStatus.failure
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: paddingSmall),
                                              child: Center(child: AppText(state.msg.toString())))
                                          : state.status == AreaStatus.loaded
                                              ? ConstrainedBox(
                                                  constraints: BoxConstraints(maxHeight: 20.h),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    itemCount: state.res.items?.length ?? 0,
                                                    itemBuilder: (buildContext, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          hideKeyboard();
                                                          lastSearchKeyword = "";
                                                          fromAreaId = state.res.items?[index].id;
                                                          fromAreaController.text = (state.res.items?[index].name).toString();
                                                          state.res.items?.clear();
                                                          context.read<FromAreaBloc>().add(const ClearFromAreaEvent());
                                                        },
                                                        child: Container(
                                                          width: 94.w,
                                                          decoration: BoxDecoration(
                                                            color: secondary.withOpacity(0.5),
                                                            border: const Border(
                                                              bottom: BorderSide(color: grey),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: AppText('${state.res.items?[index].name.toString()}'),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                );
                              },
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  AppSpacerHeight(height: 15),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Form(
                              key: toFormKey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: AppTextField(
                                textEditingController: toAreaController,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: primary,
                                ),
                                labelText: localization.to_area,
                                hintText: localization.to_area_enter,
                                textInputAction: TextInputAction.search,
                                onChanged: (value) {
                                  if (value != '') {
                                    onToAreaSearchChanged();
                                  }
                                },
                                onFieldSubmit: (value) {
                                  if (value != null && value.trim() != '') {
                                    onToAreaSearchChanged();
                                  }
                                },
                                formValidator: (value) {
                                  return FormValidate.requiredField(value!, localization.to_area_required);
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            child: BlocBuilder<ToAreaBloc, ToAreaState>(
                              builder: (context, state) {
                                return AppSwitcherWidget(
                                  animationType: 'slide',
                                  child: state.status == AreaStatus.loading
                                      ? const Padding(padding: EdgeInsets.only(top: paddingSmall), child: AppLoader())
                                      : state.status == AreaStatus.failure
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: paddingSmall),
                                              child: Center(child: AppText(state.msg.toString())))
                                          : state.status == AreaStatus.loaded
                                              ? ConstrainedBox(
                                                  constraints: BoxConstraints(maxHeight: 20.h),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    itemCount: state.res.items?.length ?? 0,
                                                    itemBuilder: (buildContext, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          hideKeyboard();
                                                          lastSearchKeyword = "";
                                                          toAreaId = state.res.items?[index].id;
                                                          toAreaController.text = (state.res.items?[index].name).toString();
                                                          state.res.items?.clear();
                                                          context.read<ToAreaBloc>().add(const ClearToAreaEvent());
                                                        },
                                                        child: Container(
                                                          width: 94.w,
                                                          decoration: BoxDecoration(
                                                            color: secondary.withOpacity(0.5),
                                                            border: const Border(
                                                              bottom: BorderSide(color: grey),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: AppText('${state.res.items?[index].name.toString()}'),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                );
                              },
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  const AppSpacerHeight(height: 15),
                  Form(
                    key: placedWorkedFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: AppTextField(
                      textEditingController: placedWorkedController,
                      labelText: localization.place,
                      hintText: localization.place_enter,
                      formValidator: (value) {
                        return FormValidate.requiredField(value!, localization.place_required);
                      },
                    ),
                  ),
                  const AppSpacerHeight(height: 15),
                  Form(
                    key: distanceFormKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: AppTextField(
                      textEditingController: distanceController,
                      labelText: localization.distance,
                      hintText: localization.distance_enter,
                      formValidator: (value) {
                        return FormValidate.requiredField(value!, localization.distance_required);
                      },
                    ),
                  ),
                  const AppSpacerHeight(height: 15),
                ],
              );
            },
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  ExpenseTypeWidget(
                    expenseType: expenseType,
                    onChanged: ((value) {
                      setState(() {
                        expenseType = value;
                        subType = null;
                      });
                    }),
                  ),
                  AppSwitcherWidget(
                    animationType: 'slide',
                    child: expenseType == 'Travel'
                        ? TravelTypeWidget(
                            travelType: subType,
                            onChanged: ((value) {
                              setState(() {
                                subType = value;
                              });
                            }),
                          )
                        : expenseType == 'Miscellaneous'
                            ? MiscTypeWidget(
                                miscType: subType,
                                onChanged: ((value) {
                                  setState(() {
                                    subType = value;
                                  });
                                }),
                              )
                            : expenseType == 'DA'
                                ? DATypeWidget(
                                    daType: subType,
                                    onChanged: ((value) {
                                      setState(() {
                                        subType = value;
                                      });
                                    }),
                                  )
                                : const AppSpacerHeight(height: 15),
                  ),
                ],
              );
            },
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              int? day = DateTime.now().difference(expenseDate).inDays;
              return CustomDatePicker(
                date: expenseDate,
                minDate: day <= 14 ? DateTime.now().subtract(const Duration(days: 14)) : null,
                maxDate: DateTime.now(),
                title: localization.select_expense_date,
                onChanged: ((value) {
                  setState(() {
                    expenseDate = value;
                  });
                }),
              );
            },
          ),
          const AppSpacerHeight(height: 15),
          Form(
            key: amountFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AmountTextFieldWidget(expenseAmountController: expenseAmountController),
          ),
          const AppSpacerHeight(height: 15),
          Form(
            key: messageFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: NoteTextFieldWidget(expenseNoteController: expenseNoteController),
          ),
          const AppSpacerHeight(height: 15),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return CommonFilePicker(
                paths: paths,
                receipts: expenseInfo.receipts!,
                deletedFileId: ((value) {
                  setState(() {
                    deletedFileId.add(value);
                  });
                }),
                onPickedFile: ((value) {
                  setState(() {
                    paths.addAll(value);
                    paths.unique();
                  });
                }),
              );
            },
          ),
          const AppSpacerHeight(height: 15),
          SizedBox(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AppButtonWithLocation(
                  btnText: localization.save,
                  onBtnClick: () async {
                    amountFormKey.currentState!.validate();
                    messageFormKey.currentState!.validate();
                    hideKeyboard();
                    if (amountFormKey.currentState!.validate() && messageFormKey.currentState!.validate()) {
                      if (subType == null) {
                        myToastMsg('Please setect subtype', isError: true);
                      } else if (paths.isNotEmpty && ((paths.length) + (expenseInfo.receipts!.length) > 5)) {
                        myToastMsg(localization.receipt_limit_error, isError: true);
                      } else {
                        try {
                          int userId = await getUserId();
                          setState(() {
                            var existingReceipts = jsonEncode(expenseInfo.receipts!);

                            formData = ((paths.isNotEmpty))
                                ? {
                                    "_method": "PUT",
                                    "user_id": userId,
                                    "from": fromAreaId,
                                    "to": toAreaId,
                                    "note": expenseNoteController.text.trim(),
                                    "expense_id": expenseId,
                                    "amount": expenseAmountController.text.trim(),
                                    "places_worked": placedWorkedController.text,
                                    "distance": distanceController.text,
                                    "type": expenseType,
                                    "sub_type": subType,
                                    "delete_receipts": deletedFileId,
                                    "receipts": paths.isNotEmpty ? paths.map((e) => e.path).toList() : null,
                                    "existing_receipts": existingReceipts,
                                    "expense_date": getDate(expenseDate.toString()),
                                  }
                                : {
                                    "_method": "PUT",
                                    "user_id": userId,
                                    "from": fromAreaId,
                                    "to": toAreaId,
                                    "expense_id": expenseId,
                                    "note": expenseNoteController.text.trim(),
                                    "amount": expenseAmountController.text.trim(),
                                    "places_worked": placedWorkedController.text,
                                    "distance": distanceController.text,
                                    "type": expenseType,
                                    "sub_type": subType,
                                    "delete_receipts": deletedFileId,
                                    "existing_receipts": existingReceipts,
                                    "expense_date": getDate(expenseDate.toString()),
                                  };
                          });
                          context.read<ExpenseBloc>().add(AddExpenseEvent(formData: formData, index: -1, reqType: reqType));
                        } catch (e) {
                          showCatchedError(e);
                        }
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
