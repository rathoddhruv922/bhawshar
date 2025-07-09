import 'package:bhawsar_chemical/data/models/expenses_model/item.dart' as expense;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../business_logic/bloc/expense/expense_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../generated/l10n.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../router/app_router.dart';
import '../../../router/route_list.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_snackbar_toast.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';
import '../../common/common_container_widget.dart';
import 'expense_info_dialog.dart';

enum ExpenseMenu { edit, delete }

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    Key? key,
    required this.expenses,
    required this.index,
  }) : super(key: key);

  final expense.Item expenses;
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
        onTap: () {
          showExpense(context, expenses);
        },
        title: Row(
          children: [
            const AppSpacerWidth(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText(
                          expenses.type ?? 'NA',
                          fontWeight: FontWeight.bold,
                          maxLine: 1,
                        ),
                        AppText(
                          ' - ${expenses.subType ?? 'NA'}',
                          fontWeight: FontWeight.bold,
                          maxLine: 1,
                        ),
                        const Spacer(),
                        // AppText(
                        //   expenses.status ?? 'NA',
                        //   fontWeight: FontWeight.normal,
                        //   color: (expenses.status == 'On Hold')
                        //       ? red
                        //       : (expenses.status == 'Complete')
                        //           ? primary
                        //           : green,
                        //   maxLine: 1,
                        // ),
                        PopupMenuButton(
                          icon: const Icon(
                            Icons.more_horiz,
                            color: primary,
                          ),
                          padding: EdgeInsets.zero,
                          position: PopupMenuPosition.under,
                          onSelected: (ExpenseMenu item) async {
                            if (item == ExpenseMenu.edit) {
                              int? day = DateTime.now().difference(DateTime.parse(expenses.expenseDate.toString())).inDays;
                              if (day <= 14) {
                                await navigationKey.currentState
                                    ?.pushNamed(
                                  RouteList.updateExpense,
                                  arguments: UpdateExpenseArguments(expenseInfo: expenses, id: expenses.id!),
                                )
                                    .then((value) {
                                  if (value == true) {
                                    context.read<ExpenseBloc>()
                                      ..add(const ClearExpenseEvent())
                                      ..add(const GetExpensesEvent(currentPage: 1, recordPerPage: 20));
                                  }
                                });
                                // if ((expenses.status == 'On Hold' || expenses.status == 'Pending')) {
                                //   await navigationKey.currentState
                                //       ?.pushNamed(
                                //     RouteList.updateExpense,
                                //     arguments: UpdateExpenseArguments(expenseInfo: expenses, id: expenses.id!),
                                //   )
                                //       .then((value) {
                                //     if (value == true) {
                                //       context.read<ExpenseBloc>()
                                //         ..add(const ClearExpenseEvent())
                                //         ..add(const GetExpensesEvent(currentPage: 1, recordPerPage: 20));
                                //     }
                                //   });
                                // } else {
                                //   myToastMsg(
                                //     'You can\'t edit this expense as its ${expenses.status}.',
                                //     isError: true,
                                //   );
                                // }
                              } else {
                                myToastMsg(
                                  localization.expense_edit_warning,
                                  isError: true,
                                );
                              }
                            } else if (item == ExpenseMenu.delete) {
                              try {
                                appAlertDialog(
                                  context,
                                  AppText(
                                    S.of(context).confirmation,
                                    textAlign: TextAlign.center,
                                    fontSize: 17,
                                  ),
                                  () {
                                    Navigator.of(context).pop();
                                    context.read<ExpenseBloc>().add(
                                          DeleteExpenseEvent(expenseId: expenses.id!, itemIndex: index),
                                        );
                                  },
                                  () => Navigator.of(context).pop(),
                                );
                              } catch (e) {
                                showCatchedError(e);
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<ExpenseMenu>>[
                            PopupMenuItem(
                              value: ExpenseMenu.edit,
                              child: TextButton.icon(
                                onPressed: null,
                                icon: const Icon(
                                  Icons.edit,
                                  color: textBlack,
                                ),
                                label: AppText(localization.edit),
                              ),
                            ),
                            PopupMenuItem(
                              value: ExpenseMenu.delete,
                              child: TextButton.icon(
                                onPressed: null,
                                icon: const Icon(
                                  Icons.delete,
                                  color: textBlack,
                                ),
                                label: AppText(localization.delete),
                              ),
                            ),
                          ],
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
                          '${expenses.note}',
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
                          currencyFormat.format(expenses.amount),
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
                        getDate(expenses.expenseDate, dateFormat: intl.DateFormat.yMMMd('en_US')),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      const AppSpacerWidth(),
                    ],
                  ),
                  // (expenses.status == 'On Hold')
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(top: 5.0),
                  //         child: AppButton(
                  //           btnText: 'Add Comment',
                  //           btnWidth: 100.w,
                  //           btnHeight: 35,
                  //           btnFontSize: 15,
                  //           btnColor: secondary,
                  //           btnTextColor: primary,
                  //           onBtnClick: () async {
                  //             Navigator.of(context).pushNamed(
                  //               RouteList.addComment,
                  //               arguments: expenses.id,
                  //             );
                  //           },
                  //         ),
                  //       )
                  //     : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
