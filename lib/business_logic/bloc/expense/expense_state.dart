part of 'expense_bloc.dart';

class ExpenseState extends Equatable {
  const ExpenseState(
      {this.status = ExpenseStatus.initial,
      this.hasReachedMax = false,
      this.res,
      this.msg});

  final String? msg;
  final dynamic res;
  final ExpenseStatus status;
  final bool hasReachedMax;

  ExpenseState copyWith(
      {dynamic res, String? msg, ExpenseStatus? status, bool? hasReachedMax}) {
    return ExpenseState(
      res: status == ExpenseStatus.initial ? null : res ?? this.res,
      msg: msg ?? this.msg,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, msg, res, hasReachedMax];
}
