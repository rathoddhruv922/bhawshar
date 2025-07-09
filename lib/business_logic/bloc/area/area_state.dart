part of 'area_bloc.dart';

class AreaState extends Equatable {
  const AreaState({this.status = AreaStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final AreaStatus status;

  @override
  List<Object?> get props => [status, msg, res];

  AreaState copyWith({dynamic res, String? msg, AreaStatus? status}) {
    return AreaState(res: res, msg: msg, status: status ?? this.status);
  }
}
