part of 'add_expense_comment_bloc.dart';

class AddExpenseCommentState extends Equatable {
  const AddExpenseCommentState(
      {this.status = ExpenseCommentStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final ExpenseCommentStatus status;

  AddExpenseCommentState copyWith({
    dynamic res,
    String? msg,
    ExpenseCommentStatus? status,
  }) {
    return AddExpenseCommentState(
      res: status == ExpenseCommentStatus.initial ? null : res ?? this.res,
      msg: msg ?? this.msg,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status, msg, res];
}
