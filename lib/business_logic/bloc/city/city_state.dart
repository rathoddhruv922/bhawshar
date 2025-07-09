part of 'city_bloc.dart';

class CityState extends Equatable {
  const CityState({this.status = CityStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final CityStatus status;

  @override
  List<Object?> get props => [status, msg, res];

  CityState copyWith({dynamic res, String? msg, CityStatus? status}) {
    return CityState(
        res: res ?? this.res,
        msg: msg ?? this.msg,
        status: status ?? this.status);
  }
}
