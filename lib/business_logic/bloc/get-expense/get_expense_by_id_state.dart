part of 'get_expense_by_id_bloc.dart';

class ExpenseByIdState extends Equatable {
  const ExpenseByIdState(
      {this.status = ExpenseByIdStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final ExpenseByIdStatus status;

  ExpenseByIdState copyWith(
      {dynamic res, String? msg, ExpenseByIdStatus? status}) {
    return ExpenseByIdState(
      res: status == ExpenseByIdStatus.initial ? null : res ?? this.res,
      msg: msg ?? this.msg,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status, msg, res];
}
