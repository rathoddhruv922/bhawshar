part of 'feedback_bloc.dart';

class FeedbackState extends Equatable {
  const FeedbackState(
      {this.status = FeedbackStatus.initial,
      this.hasReachedMax = false,
      this.res,
      this.msg});

  final String? msg;
  final dynamic res;
  final FeedbackStatus status;
  final bool hasReachedMax;

  FeedbackState copyWith(
      {dynamic res, String? msg, FeedbackStatus? status, bool? hasReachedMax}) {
    return FeedbackState(
      res: status == FeedbackStatus.initial ? null : res ?? this.res,
      msg: msg ?? this.msg,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, msg, res, hasReachedMax];
}
