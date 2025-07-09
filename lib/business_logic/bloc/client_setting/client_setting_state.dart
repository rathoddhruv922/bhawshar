part of 'client_setting_bloc.dart';

class ClientSettingState extends Equatable {
  const ClientSettingState(
      {this.status = ClientSettingStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final ClientSettingStatus status;

  @override
  List<Object?> get props => [status, msg, res];

  ClientSettingState copyWith(
      {dynamic res, String? msg, ClientSettingStatus? status}) {
    return ClientSettingState(
        res: res ?? this.res,
        msg: msg ?? this.msg,
        status: status ?? this.status);
  }
}
