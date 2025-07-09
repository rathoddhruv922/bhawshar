part of 'client_setting_bloc.dart';

abstract class ClientSettingEvent extends Equatable {
  const ClientSettingEvent();

  @override
  List<Object> get props => [];
}

class GetClientSettingEvent extends ClientSettingEvent {
  const GetClientSettingEvent();

  @override
  List<Object> get props => [];
}

class ClearSettingEvent extends ClientSettingEvent {
  const ClearSettingEvent();

  @override
  List<Object> get props => [];
}
