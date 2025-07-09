part of 'to_area_bloc.dart';

class ToAreaState extends Equatable {
  const ToAreaState({this.status = AreaStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final AreaStatus status;

  @override
  List<Object?> get props => [status, msg, res];

  ToAreaState copyWith({dynamic res, String? msg, AreaStatus? status}) {
    return ToAreaState(res: res, msg: msg, status: status ?? this.status);
  }
}
