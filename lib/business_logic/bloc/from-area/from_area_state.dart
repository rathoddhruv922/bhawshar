part of 'from_area_bloc.dart';

class FromAreaState extends Equatable {
  const FromAreaState({this.status = AreaStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final AreaStatus status;

  @override
  List<Object?> get props => [status, msg, res];

  FromAreaState copyWith({dynamic res, String? msg, AreaStatus? status}) {
    return FromAreaState(res: res, msg: msg, status: status ?? this.status);
  }
}
