import 'package:bhawsar_chemical/src/screens/expense/widget/expense_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants/app_const.dart';
import '../../../../helper/app_helper.dart';
import '../../../../main.dart';
import '../../../../utils/app_colors.dart';
import '../../../business_logic/bloc/expense/expense_bloc.dart';
import '../../../constants/enums.dart';
import '../../router/route_list.dart';
import '../../widgets/app_animated_dialog.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_connection_widget.dart';
import '../../widgets/app_dialog_loader.dart';
import '../../widgets/app_snackbar_toast.dart';
import '../../widgets/app_text.dart';
import '../common/common_reload_widget.dart';

import 'dart:math' as math;

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    context.read<ExpenseBloc>()
      ..add(const ClearExpenseEvent())
      ..add(const GetExpensesEvent(currentPage: 1, recordPerPage: 20));
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      appBar: CustomAppBar(
        AppText(
          localization.travel_food_expense_s,
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: green,
        heroTag: "${math.Random().nextDouble()}",
        onPressed: () async {
          navigationKey.currentState?.restorablePushNamed(
            RouteList.addExpense,
          );
        },
        icon: const Icon(
          Icons.add,
          color: white,
        ),
        label: AppText(
          localization.add_expense,
          color: white,
        ),
      ),
      body: SafeArea(
        child: ConnectionStatus(
          isShowAnimation: true,
          child: Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: BlocConsumer<ExpenseBloc, ExpenseState>(
                listenWhen: (previous, current) {
              if ((previous.status == ExpenseStatus.updating ||
                  previous.status == ExpenseStatus.adding)) {
                return false;
              }
              return true;
            }, listener: (context, state) async {
              if (state.status == ExpenseStatus.loading ||
                  state.status == ExpenseStatus.deleting) {
                showAnimatedDialog(
                    navigationKey.currentContext!, const AppDialogLoader());
              }
              if (state.status == ExpenseStatus.deleted ||
                  state.status == ExpenseStatus.failure) {
                Navigator.of(context).pop();
                mySnackbar(state.msg.toString(),
                    isError:
                        state.status == ExpenseStatus.failure ? true : false);
                await Future.delayed(const Duration(seconds: 1));
              }
              if (state.status == ExpenseStatus.loaded) {
                Navigator.of(context).pop();
              }
            }, buildWhen: (previous, current) {
              if (previous.status == ExpenseStatus.adding ||
                  previous.status == ExpenseStatus.updating) {
                return false;
              } else if (current.status == ExpenseStatus.deleted ||
                  current.status == ExpenseStatus.loaded ||
                  current.status == ExpenseStatus.initial ||
                  current.res == null &&
                      current.status == ExpenseStatus.failure) {
                return true;
              }
              return false;
            }, builder: (context, state) {
              if (state.status == ExpenseStatus.initial) {
                return Center(child: AppText(state.msg.toString()));
              }
              if (state.res == null && state.status == ExpenseStatus.failure) {
                return CommonReloadWidget(
                    message: state.msg,
                    reload: state.msg.toString() == localization.network_error
                        ? (context.read<ExpenseBloc>()
                          ..add(const ClearExpenseEvent())
                          ..add(const GetExpensesEvent(
                              currentPage: 1, recordPerPage: 20)))
                        : null);
              }
              if (state.status == ExpenseStatus.loaded ||
                  state.status == ExpenseStatus.deleted) {
                return state.res.items?.length == 0
                    ? Center(child: AppText(localization.empty))
                    : ExpenseList(
                        hasReachedMax: state.hasReachedMax,
                        expenseList: state.res);
              }

              return const SizedBox.shrink();
            }),
          ),
        ),
      ),
    );
  }
}
