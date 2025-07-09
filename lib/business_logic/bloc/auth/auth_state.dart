part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({this.status = AuthStateStatus.loading, this.res, this.msg});

  final dynamic res;
  final String? msg;
  final AuthStateStatus status;

  @override
  List<Object?> get props => [status, msg, res];

  AuthState copyWith({dynamic res, String? msg, AuthStateStatus? status}) {
    return AuthState(res: res, msg: msg, status: status ?? this.status);
  }
}
