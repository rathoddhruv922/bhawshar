part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class ChangePasswordEvent extends AuthEvent {
  final String oldPassword, newPassword, confirmPassword;

  ChangePasswordEvent({required this.oldPassword, required this.newPassword, required this.confirmPassword});

  @override
  List<Object?> get props => [oldPassword, newPassword, confirmPassword];
}

class ResetPasswordEvent extends AuthEvent {
  final String email, token, newPassword, confirmPassword;

  ResetPasswordEvent({
    required this.email,
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, token, newPassword, confirmPassword];
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class ConfirmOtpEvent extends AuthEvent {
  final String otp;

  ConfirmOtpEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class CheckLoginEvent extends AuthEvent {}

class LogOutEvent extends AuthEvent {}

class TokenExpiredEvent extends AuthEvent {}
