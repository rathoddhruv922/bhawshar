part of 'comment_bloc.dart';

class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class AddCommentEvent extends CommentEvent {
  final Map<String, dynamic> formData;
  final String reqType;
  final int index;

  const AddCommentEvent(
      {required this.formData, required this.index, required this.reqType});

  @override
  List<Object> get props => [formData, index, reqType];
}

class ClearCommentEvent extends CommentEvent {
  const ClearCommentEvent();

  @override
  List<Object> get props => [];
}
