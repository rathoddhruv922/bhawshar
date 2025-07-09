import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_logic/bloc/expense/expense_bloc.dart';
import '../../../../data/models/expenses_model/expenses_model.dart';
import '../../../../main.dart';
import '../../../widgets/app_loader_simple.dart';
import '../../../widgets/app_text.dart';
import 'expense_card_widget.dart';

class ExpenseList extends StatefulWidget {
  final ExpensesModel expenseList;
  final bool hasReachedMax;

  const ExpenseList({Key? key, required this.expenseList, required this.hasReachedMax}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context
          .read<ExpenseBloc>()
          .add(GetExpensesEvent(currentPage: widget.expenseList.meta!.currentPage! + 1, recordPerPage: 20));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.90) && !_scrollController.position.outOfRange;
  }

  @override
  Widget build(BuildContext context) {
    return
        // CustomRefreshIndicator(
        //   onRefresh: () async {
        //     context.read<ExpenseBloc>()
        //       ..add(const ClearExpenseEvent())
        //       ..add(const GetExpensesEvent(currentPage: 1, recordPerPage: 20));
        //   },
        //   builder: (
        //     BuildContext context,
        //     Widget child,
        //     IndicatorController controller,
        //   ) {
        //     return RefreshIndi(context, controller, child, 50);
        //   },
        // child:
        ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.expenseList.items!.length + 1,
      itemBuilder: (buildContext, index) {
        if (index >= widget.expenseList.items!.length) {
          return widget.hasReachedMax
              ? Center(
                  child: AppText(localization.no_more_data),
                )
              : const AppLoader();
        } else {
          return ExpenseCard(expenses: widget.expenseList.items![index], index: index);
        }
      },
      // ),
    );
  }
}
