import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/expense_model/expense_model.dart';
import 'package:bhawsar_chemical/data/repositories/expense_repository.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'get_expense_by_id_event.dart';
part 'get_expense_by_id_state.dart';

const throttleDuration = Duration(milliseconds: 100);

class ExpenseByIdBloc extends Bloc<ExpenseByIdEvent, ExpenseByIdState> {
  final ExpenseRepository expenseRepository;
  ExpenseByIdBloc(this.expenseRepository) : super(const ExpenseByIdState()) {
    on<ClearExpenseByIdEvent>(_onClearExpenseById,
        transformer: throttleSequentials(throttleDuration));
    on<GetExpenseByIdEvent>(_onGetExpenseById,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onClearExpenseById(
      ClearExpenseByIdEvent event, Emitter<ExpenseByIdState> emit) async {
    emit(state.copyWith(
        status: ExpenseByIdStatus.initial, msg: localization.loading));
  }

  Future<void> _onGetExpenseById(
      GetExpenseByIdEvent event, Emitter<ExpenseByIdState> emit) async {
    emit(state.copyWith(status: ExpenseByIdStatus.loading));
    try {
      ApiResult<ExpenseModel> apiResult =
          await expenseRepository.getExpenseById(event.expenseId);
      apiResult.when(success: (ExpenseModel data) async {
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: ExpenseByIdStatus.loaded,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          status: ExpenseByIdStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        msg: (e.toString()),
        status: ExpenseByIdStatus.failure,
      ));
    }
  }
}
