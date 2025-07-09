part of 'expense_bloc.dart';

class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class GetExpensesEvent extends ExpenseEvent {
  final int currentPage, recordPerPage;
  const GetExpensesEvent(
      {required this.currentPage, required this.recordPerPage});

  @override
  List<Object> get props => [currentPage, recordPerPage];
}

class AddExpenseEvent extends ExpenseEvent {
  final Map<String, dynamic> formData;
  final String reqType;
  final int index;

  const AddExpenseEvent(
      {required this.formData, required this.index, required this.reqType});

  @override
  List<Object> get props => [formData, index, reqType];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final int? expenseId, itemIndex;

  const DeleteExpenseEvent({required this.expenseId, required this.itemIndex});

  @override
  List<Object?> get props => [expenseId, itemIndex];
}

class ClearExpenseEvent extends ExpenseEvent {
  const ClearExpenseEvent();

  @override
  List<Object> get props => [];
}
