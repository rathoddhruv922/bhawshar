part of 'reminder_bloc.dart';

class ReminderState extends Equatable {
  const ReminderState({
    this.status = ReminderStatus.initial,
    this.res,
    this.msg,
    this.hasReachedMax = false,
  });

  final String? msg;
  final dynamic res;
  final ReminderStatus status;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [status, msg, res, hasReachedMax];

  ReminderState copyWith({
    dynamic res,
    String? msg,
    ReminderStatus? status,
    bool? hasReachedMax,
  }) {
    return ReminderState(
      res: status == ReminderStatus.initial ? null : res ?? this.res,
      msg: msg ?? this.msg,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
