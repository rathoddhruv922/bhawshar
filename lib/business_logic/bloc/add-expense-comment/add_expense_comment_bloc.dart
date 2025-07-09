import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/repositories/expense_repository.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'add_expense_comment_event.dart';
part 'add_expense_comment_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class AddExpenseCommentBloc
    extends Bloc<AddExpenseCommentEvent, AddExpenseCommentState> {
  final ExpenseRepository expenseRepository;
  AddExpenseCommentBloc(this.expenseRepository)
      : super(const AddExpenseCommentState()) {
    on<ClearExpenseEvent>(_onClearExpense,
        transformer: throttleSequentials(throttleDuration));
    on<AddCommentToExpenseEvent>(_onAddExpenseComment,
        transformer: throttleSequentials(throttleDuration));
  }

  Future<void> _onClearExpense(
      ClearExpenseEvent event, Emitter<AddExpenseCommentState> emit) async {
    emit(state.copyWith(
        status: ExpenseCommentStatus.initial, msg: localization.loading));
  }

  Future<void> _onAddExpenseComment(AddCommentToExpenseEvent event,
      Emitter<AddExpenseCommentState> emit) async {
    emit(state.copyWith(
      status: ExpenseCommentStatus.adding,
    ));
    try {
      ApiResult<Response> apiResult =
          await expenseRepository.addCommentToExpense(
        event.formData,
      );

      await apiResult.when(success: (Response data) async {
        emit(
          state.copyWith(
            msg: data.data['message'],
            status: ExpenseCommentStatus.added,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          status: ExpenseCommentStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: ExpenseCommentStatus.failure,
      ));
    }
  }
}
