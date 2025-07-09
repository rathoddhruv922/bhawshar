import 'package:bhawsar_chemical/business_logic/bloc/add-expense-comment/add_expense_comment_bloc.dart';
import 'package:bhawsar_chemical/business_logic/bloc/get-expense/get_expense_by_id_bloc.dart';
import 'package:bhawsar_chemical/src/screens/common/common_container_widget.dart';
import 'package:bhawsar_chemical/src/widgets/app_loader_simple.dart';
import 'package:bhawsar_chemical/src/widgets/app_text_field.dart';
import 'package:bhawsar_chemical/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../constants/app_const.dart';
import '../../../../constants/enums.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/app_animated_dialog.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_button_with_location.dart';
import '../../../widgets/app_dialog_loader.dart';
import '../../../widgets/app_snackbar_toast.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';

import 'package:bhawsar_chemical/data/models/expense_model/expense.dart'
    as expense;

class AddCommentToExpenseScreen extends StatelessWidget {
  final int expenseId;
  const AddCommentToExpenseScreen({super.key, required this.expenseId});
  @override
  Widget build(BuildContext context) {
    context
        .read<ExpenseByIdBloc>()
        .add(GetExpenseByIdEvent(expenseId: expenseId));
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: offWhite,
      appBar: CustomAppBar(
        AppText(
          localization.comment_add,
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
      body: BlocListener<ExpenseByIdBloc, ExpenseByIdState>(
        listener: (context, state) async {
          if (state.status == ExpenseByIdStatus.loading) {
            showAnimatedDialog(context, const AppDialogLoader());
          } else if (state.status == ExpenseByIdStatus.loaded) {
            Navigator.pop(context); // for close Loader
          } else if (state.status == ExpenseByIdStatus.failure) {
            Navigator.of(context).pop();
            mySnackbar(state.msg.toString(), isError: true);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(paddingDefault),
          physics: const AlwaysScrollableScrollPhysics(),
          child: UpdateExpenseFormWidget(),
        ),
      ),
    );
  }
}

class UpdateExpenseFormWidget extends StatelessWidget {
  const UpdateExpenseFormWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> messageFormKey = GlobalKey<FormState>();
    TextEditingController commentController = TextEditingController();

    return SafeArea(
      child: BlocBuilder<ExpenseByIdBloc, ExpenseByIdState>(
        buildWhen: (pre, cur) => cur.status == ExpenseByIdStatus.loaded,
        builder: (context, state) {
          if (state.status == ExpenseByIdStatus.loaded) {
            expense.Expense? expenseInfo = state.res.expense;
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                CommonContainer(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppText(
                              expenseInfo?.type ?? 'NA',
                              fontWeight: FontWeight.bold,
                              maxLine: 1,
                            ),
                            AppText(
                              ' - ${expenseInfo?.subType ?? 'NA'}',
                              fontWeight: FontWeight.bold,
                              maxLine: 1,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: AppText(
                              '${expenseInfo?.note}',
                              maxLine: 1,
                            ),
                          ),
                        ],
                      ),
                      const AppSpacerHeight(height: 5),
                      Row(
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
                                  offset: const Offset(
                                      0, 0.5), // changes position of shadow
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
                              currencyFormat.format(expenseInfo?.amount),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.calendar_month,
                            size: 15.sp,
                            color: primary,
                          ),
                          const AppSpacerWidth(width: 5),
                          AppText(
                            getDate(expenseInfo?.expenseDate,
                                dateFormat: intl.DateFormat.yMMMd('en_US')),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          const AppSpacerWidth(),
                        ],
                      ),
                    ],
                  ),
                ),
                (expenseInfo?.comments?.isEmpty ?? true)
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: AppText(
                          'Comments',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  shrinkWrap: true,
                  children: expenseInfo!.comments!.map((item) {
                    return Row(
                      mainAxisAlignment: item.role == 'MR'
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 75.w),
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft:
                                    Radius.circular(item.role == 'MR' ? 8 : 0),
                                bottomRight:
                                    Radius.circular(item.role == 'MR' ? 0 : 8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: const Offset(
                                      0, 0.5), // changes position of shadow
                                ),
                              ],
                            ),
                            padding: EdgeInsets.fromLTRB(
                                item.role == 'MR' ? 5.0 : 8.0,
                                5.0,
                                item.role == 'MR' ? 8.0 : 5.0,
                                5.0),
                            child: AppText(
                              item.comment ?? 'N/A',
                              textAlign: item.role == 'MR'
                                  ? TextAlign.right
                                  : TextAlign.left,
                              maxLine: 10,
                            ),
                          ),
                        )
                      ],
                    );
                  }).toList(),
                ),
                const AppSpacerHeight(height: 10),
                Form(
                  key: messageFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: AppTextField(
                    textEditingController: commentController,
                    labelText: localization.comment_add,
                    hintText: localization.type_comment,
                    maxLine: 10,
                    textInputAction: TextInputAction.done,
                    minLine: 2,
                    formValidator: (value) {
                      return FormValidate.requiredField(
                          value!, localization.comment_required);
                    },
                  ),
                ),
                const AppSpacerHeight(height: 15),
                SizedBox(
                  child: BlocListener<AddExpenseCommentBloc,
                      AddExpenseCommentState>(
                    listener: (context, state) async {
                      if (state.status == ExpenseCommentStatus.adding) {
                        showAnimatedDialog(navigationKey.currentContext!,
                            const AppDialogLoader());
                      } else if (state.status == ExpenseCommentStatus.failure) {
                        Navigator.pop(context); // for close Loader
                        mySnackbar(state.msg.toString(), isError: true);
                      } else if (state.status == ExpenseCommentStatus.added) {
                        Navigator.pop(context); // for close Loader
                        mySnackbar(state.msg.toString());
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: AppButtonWithLocation(
                        btnText: localization.save,
                        onBtnClick: () async {
                          messageFormKey.currentState!.validate();
                          hideKeyboard();
                          if (messageFormKey.currentState!.validate()) {
                            try {
                              context
                                  .read<AddExpenseCommentBloc>()
                                  .add(AddCommentToExpenseEvent(
                                    formData: {
                                      "expense_id": expenseInfo.id,
                                      "comment": commentController.text.trim(),
                                    },
                                  ));
                            } catch (e) {
                              showCatchedError(e);
                            }
                          }
                        }),
                  ),
                ),
              ],
            );
          } else {
            return AppLoader();
          }
        },
      ),
    );
  }
}
