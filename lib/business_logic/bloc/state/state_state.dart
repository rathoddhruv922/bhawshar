part of 'state_bloc.dart';

class StateState extends Equatable {
  const StateState({this.status = StateStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final StateStatus status;

  @override
  List<Object?> get props => [status, msg, res];

  StateState copyWith({dynamic res, String? msg, StateStatus? status}) {
    return StateState(res: res, msg: msg, status: status ?? this.status);
  }
}
