import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/expenses_model/expenses_model.dart';
import 'package:bhawsar_chemical/data/repositories/expense_repository.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'expense_event.dart';
part 'expense_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepository;
  ExpenseBloc(this.expenseRepository) : super(const ExpenseState()) {
    on<ClearExpenseEvent>(_onClearExpense,
        transformer: throttleSequentials(throttleDuration));
    on<GetExpensesEvent>(_onGetExpenses,
        transformer: throttleDroppable(throttleDuration));
    on<DeleteExpenseEvent>(_onDeleteExpense,
        transformer: throttleSequentials(throttleDuration));
    on<AddExpenseEvent>(_onAddExpense,
        transformer: throttleSequentials(throttleDuration));
  }

  Future<void> _onClearExpense(
      ClearExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(state.copyWith(
        status: ExpenseStatus.initial, msg: localization.loading));
  }

  Future<void> _onGetExpenses(
      GetExpensesEvent event, Emitter<ExpenseState> emit) async {
    if (state.hasReachedMax &&
        event.currentPage != 1 &&
        state.status != ExpenseStatus.updated &&
        state.status != ExpenseStatus.deleted &&
        state.status != ExpenseStatus.added) return;
    emit(state.copyWith(status: ExpenseStatus.loading));
    try {
      ApiResult<ExpensesModel> apiResult = await expenseRepository.getExpenses(
          event.currentPage, event.recordPerPage);
      apiResult.when(success: (ExpensesModel data) async {
        updateFeedbackCount(data.openFeedback ?? 0);
        ExpensesModel? expenseList;
        if (state.res != null &&
            event.currentPage <= data.meta!.lastPage! &&
            event.currentPage != 1) {
          expenseList = state.res;
          expenseList?.items?.addAll(data.items!);
          expenseList?.meta = data.meta;
          // expenseList?.items?.unique();
        } else {
          expenseList = data;
          // expenseList.items?.unique();
        }
        emit(
          state.copyWith(
            res: expenseList,
            msg: data.message,
            status: ExpenseStatus.loaded,
            hasReachedMax:
                event.currentPage == data.meta!.lastPage ? true : false,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          status: ExpenseStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: ExpenseStatus.failure,
      ));
    }
  }

  Future<void> _onAddExpense(
      AddExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(state.copyWith(
      status: event.reqType == 'post'
          ? ExpenseStatus.adding
          : ExpenseStatus.updating,
    ));
    try {
      ApiResult<Response> apiResult = await expenseRepository.addExpenseDetail(
        event.formData,
        reqType: event.reqType,
      );

      await apiResult.when(success: (Response data) async {
        emit(
          state.copyWith(
            msg: data.data['message'],
            status: event.reqType == 'post'
                ? ExpenseStatus.added
                : ExpenseStatus.updated,
            hasReachedMax: false,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          // res: event.reqType == 'post' ? 'Error!' : state.res,
          status: ExpenseStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: ExpenseStatus.failure,
      ));
    }
  }

  Future<void> _onDeleteExpense(
      DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(state.copyWith(
      status: ExpenseStatus.deleting,
    ));
    try {
      ApiResult<Response> apiResult = await expenseRepository.deleteExpense(
          event.expenseId, event.itemIndex);
      apiResult.when(success: (Response data) async {
        ExpensesModel expenseList = state.res;
        expenseList.items?.removeAt(event.itemIndex!);
        emit(state.copyWith(
          res: expenseList,
          msg: data.data['message'],
          status: ExpenseStatus.deleted,
        ));
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          msg: DioExceptions.getErrorMSg(error),
          status: ExpenseStatus.failure,
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: ExpenseStatus.failure,
      ));
    }
  }
}
