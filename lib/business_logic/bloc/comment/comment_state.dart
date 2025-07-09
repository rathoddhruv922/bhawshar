part of 'comment_bloc.dart';

class CommentState extends Equatable {
  const CommentState(
      {this.status = CommentStatus.initial,
      this.hasReachedMax = false,
      this.res,
      this.msg});

  final String? msg;
  final dynamic res;
  final CommentStatus status;
  final bool hasReachedMax;

  CommentState copyWith(
      {dynamic res, String? msg, CommentStatus? status, bool? hasReachedMax}) {
    return CommentState(
      res: status == CommentStatus.initial ? null : res ?? this.res,
      msg: msg ?? this.msg,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, msg, res, hasReachedMax];
}
