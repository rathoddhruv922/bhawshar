part of 'get_expense_by_id_bloc.dart';

class ExpenseByIdEvent extends Equatable {
  const ExpenseByIdEvent();

  @override
  List<Object?> get props => [];
}

class GetExpenseByIdEvent extends ExpenseByIdEvent {
  final int expenseId;
  const GetExpenseByIdEvent({required this.expenseId});

  @override
  List<Object> get props => [expenseId];
}

class AddExpenseEvent extends ExpenseByIdEvent {
  final Map<String, dynamic> formData;
  final String reqType;
  final int index;

  const AddExpenseEvent(
      {required this.formData, required this.index, required this.reqType});

  @override
  List<Object> get props => [formData, index, reqType];
}

class DeleteExpenseEvent extends ExpenseByIdEvent {
  final int? expenseId, itemIndex;

  const DeleteExpenseEvent({required this.expenseId, required this.itemIndex});

  @override
  List<Object?> get props => [expenseId, itemIndex];
}

class ClearExpenseByIdEvent extends ExpenseByIdEvent {
  const ClearExpenseByIdEvent();

  @override
  List<Object> get props => [];
}
