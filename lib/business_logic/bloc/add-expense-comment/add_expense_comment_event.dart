part of 'add_expense_comment_bloc.dart';

class AddExpenseCommentEvent extends Equatable {
  const AddExpenseCommentEvent();

  @override
  List<Object?> get props => [];
}

class AddCommentToExpenseEvent extends AddExpenseCommentEvent {
  final Map<String, dynamic> formData;

  const AddCommentToExpenseEvent({required this.formData});

  @override
  List<Object> get props => [formData];
}

class ClearExpenseEvent extends AddExpenseCommentEvent {
  const ClearExpenseEvent();

  @override
  List<Object> get props => [];
}
