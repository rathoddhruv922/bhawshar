import 'dart:async';
import 'package:bhawsar_chemical/business_logic/bloc/from-area/from_area_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/to-area/to_area_bloc.dart';
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

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    String? reqType = 'post';

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        AppText(
          localization.add_expense,
          color: primary,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: getBackArrow(),
          color: primary,
        ),
      ),
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) async {
          if (state.status == ExpenseStatus.adding) {
            showAnimatedDialog(
                navigationKey.currentContext!, const AppDialogLoader());
          } else if (state.status == ExpenseStatus.added) {
            Navigator.of(context).pop(); // for close Loader
            mySnackbar(state.msg.toString());
            Navigator.of(context).pop(false);
            await Future.delayed(const Duration(milliseconds: 500));
            navigationKey.currentContext?.read<ExpenseBloc>().add(
                  const GetExpensesEvent(currentPage: 1, recordPerPage: 20),
                );
          } else if (state.status == ExpenseStatus.failure) {
            Navigator.of(context).pop();
            mySnackbar(state.msg.toString(),
                isError: state.status == ExpenseStatus.failure ? true : false);
            await Future.delayed(const Duration(seconds: 1));
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(paddingDefault),
          child: AddExpenseFormWidget(
            reqType: reqType,
          ),
        ),
      ),
    );
  }
}

class AddExpenseFormWidget extends StatelessWidget {
  final String? reqType;

  const AddExpenseFormWidget({Key? key, this.reqType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> placedWorkedFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> distanceFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> amountFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> messageFormKey = GlobalKey<FormState>();
    DateTime expenseDate = DateTime.now();

    Map<String, dynamic> formData = {};
    TextEditingController placedWorkedController = TextEditingController();
    TextEditingController distanceController = TextEditingController();
    TextEditingController expenseNoteController = TextEditingController();
    TextEditingController expenseAmountController = TextEditingController();

    String expenseType = 'Travel';
    String? subType;
    List<PlatformFile>? paths = [];

    String? lastSearchKeyword;
    Timer? debounce;
    int? fromAreaId, toAreaId;
    TextEditingController fromAreaController = TextEditingController();
    TextEditingController toAreaController = TextEditingController();
    final GlobalKey<FormState> fromFormKey = GlobalKey<FormState>();
    final GlobalKey<FormState> toFormKey = GlobalKey<FormState>();

    onFromAreaSearchChanged() async {
      if (debounce?.isActive ?? false) debounce!.cancel();
      debounce = Timer(const Duration(milliseconds: 700), () {
        if (fromAreaController.text.trim() != "" &&
            lastSearchKeyword != fromAreaController.text.trim()) {
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
        if (toAreaController.text.trim() != "" &&
            lastSearchKeyword != toAreaController.text.trim()) {
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                return FormValidate.requiredField(
                                    value!, localization.from_area_required);
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
                                    ? const Padding(
                                        padding:
                                            EdgeInsets.only(top: paddingSmall),
                                        child: AppLoader())
                                    : state.status == AreaStatus.failure
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: paddingSmall),
                                            child: Center(
                                                child: AppText(
                                                    state.msg.toString())))
                                        : state.status == AreaStatus.loaded
                                            ? ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxHeight: 20.h),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount:
                                                      state.res.items?.length ??
                                                          0,
                                                  itemBuilder:
                                                      (buildContext, index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        hideKeyboard();
                                                        lastSearchKeyword = "";
                                                        fromAreaId = state.res
                                                            .items?[index].id;
                                                        fromAreaController
                                                            .text = (state
                                                                .res
                                                                .items?[index]
                                                                .name)
                                                            .toString();
                                                        state.res.items
                                                            ?.clear();
                                                        context
                                                            .read<
                                                                FromAreaBloc>()
                                                            .add(
                                                                const ClearFromAreaEvent());
                                                      },
                                                      child: Container(
                                                        width: 94.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: secondary
                                                              .withOpacity(0.5),
                                                          border: const Border(
                                                            bottom: BorderSide(
                                                                color: grey),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: AppText(
                                                              '${state.res.items?[index].name.toString()}'),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                return FormValidate.requiredField(
                                    value!, localization.to_area_required);
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
                                    ? const Padding(
                                        padding:
                                            EdgeInsets.only(top: paddingSmall),
                                        child: AppLoader())
                                    : state.status == AreaStatus.failure
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: paddingSmall),
                                            child: Center(
                                                child: AppText(
                                                    state.msg.toString())))
                                        : state.status == AreaStatus.loaded
                                            ? ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxHeight: 20.h),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount:
                                                      state.res.items?.length ??
                                                          0,
                                                  itemBuilder:
                                                      (buildContext, index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        hideKeyboard();
                                                        lastSearchKeyword = "";
                                                        toAreaId = state.res
                                                            .items?[index].id;
                                                        toAreaController
                                                            .text = (state
                                                                .res
                                                                .items?[index]
                                                                .name)
                                                            .toString();
                                                        state.res.items
                                                            ?.clear();
                                                        context
                                                            .read<ToAreaBloc>()
                                                            .add(
                                                                const ClearToAreaEvent());
                                                      },
                                                      child: Container(
                                                        width: 94.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: secondary
                                                              .withOpacity(0.5),
                                                          border: const Border(
                                                            bottom: BorderSide(
                                                                color: grey),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: AppText(
                                                              '${state.res.items?[index].name.toString()}'),
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
                      return FormValidate.requiredField(
                          value!, localization.place_required);
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
                      return FormValidate.requiredField(
                          value!, localization.distance_required);
                    },
                  ),
                ),
                const AppSpacerHeight(height: 15),
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
          }),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return CustomDatePicker(
              date: expenseDate,
              minDate: DateTime.now().subtract(const Duration(days: 14)),
              maxDate: DateTime.now(),
              title: localization.select_expense_date,
              onChanged: ((value) {
                setState(() {
                  expenseDate = value;
                });
              }),
            );
          }),
          const AppSpacerHeight(height: 15),
          Form(
            key: amountFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AmountTextFieldWidget(
                expenseAmountController: expenseAmountController),
          ),
          const AppSpacerHeight(height: 15),
          Form(
            key: messageFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: NoteTextFieldWidget(
                expenseNoteController: expenseNoteController),
          ),
          const AppSpacerHeight(height: 15),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return CommonFilePicker(
                paths: paths,
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
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                child: AppButtonWithLocation(
                    btnText: localization.save,
                    onBtnClick: () async {
                      amountFormKey.currentState!.validate();
                      messageFormKey.currentState!.validate();
                      placedWorkedFormKey.currentState!.validate();
                      distanceFormKey.currentState!.validate();
                      hideKeyboard();
                      if (fromAreaId == null) {
                        myToastMsg('Please select from area', isError: true);
                      } else if (toAreaId == null) {
                        myToastMsg('Please select to area', isError: true);
                      } else if (amountFormKey.currentState!.validate() &&
                          messageFormKey.currentState!.validate() &&
                          placedWorkedFormKey.currentState!.validate() &&
                          distanceFormKey.currentState!.validate()) {
                        if (subType == null) {
                          myToastMsg(localization.select_subtype,
                              isError: true);
                        } else if (paths.isNotEmpty && (paths.length > 5)) {
                          myToastMsg(localization.receipt_limit_error,
                              isError: true);
                        } else {
                          try {
                            int userId = await getUserId();
                            setState(() {
                              formData = paths.isNotEmpty
                                  ? {
                                      "user_id": userId,
                                      "from": fromAreaId,
                                      "to": toAreaId,
                                      "expense_id": -1,
                                      "note": expenseNoteController.text.trim(),
                                      "amount":
                                          expenseAmountController.text.trim(),
                                      "places_worked":
                                          placedWorkedController.text,
                                      "distance": distanceController.text,
                                      "reqType": reqType,
                                      "type": expenseType,
                                      "sub_type": subType,
                                      "receipts": paths.isNotEmpty
                                          ? paths.map((e) => e.path).toList()
                                          : null,
                                      "expense_date":
                                          getDate(expenseDate.toString()),
                                    }
                                  : {
                                      "user_id": userId,
                                      "from": fromAreaId,
                                      "to": toAreaId,
                                      "expense_id": -1,
                                      "note": expenseNoteController.text
                                          .trim()
                                          .toString(),
                                      "amount": expenseAmountController.text
                                          .trim()
                                          .toString(),
                                      "places_worked":
                                          placedWorkedController.text,
                                      "distance": distanceController.text,
                                      "reqType": reqType,
                                      "type": expenseType,
                                      "sub_type": subType,
                                      "expense_date":
                                          getDate(expenseDate.toString()),
                                    };
                            });
                            context.read<ExpenseBloc>().add(AddExpenseEvent(
                                formData: formData,
                                index: -1,
                                reqType: reqType ?? 'post'));
                          } catch (e) {
                            showCatchedError(e);
                          }
                        }
                      }
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
