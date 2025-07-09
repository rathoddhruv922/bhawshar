import 'dart:async';
import 'dart:convert';

import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/repositories/user_repository.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _userRepository = UserRepository();

  AuthBloc() : super(const AuthState()) {
    on<LoginEvent>(_onLogin);
    on<CheckLoginEvent>(_onCheckLogin);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ConfirmOtpEvent>(_onConfirmOtp);
    on<ChangePasswordEvent>(_onChangePassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<LogOutEvent>(_onLogOut);
    on<TokenExpiredEvent>(_onTokenExpired);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    try {
      ApiResult<Response> apiResult = await _userRepository.userLogin(event.email, event.password);
      apiResult.when(success: (Response data) async {
        emit(
          state.copyWith(
            status: AuthStateStatus.authenticated,
            res: data,
            msg: 'successful',
          ),
        );
        try {
          await userBox.put('authToken', data.data['token']);
          await userBox.put('userInfo', data.data['data']);
          await updateNotificationCount(data.data['reminder_count'] ?? 0);
          await updateUserInfo(data.data['data'] ?? {});
          await updateFeedbackCount(data.data['open_feedback'] ?? 0);
        } catch (e) {
          await userBox.put('authToken', null);
          emit(
            state.copyWith(status: AuthStateStatus.unAuthenticated, msg: e.toString()),
          );
        }
      }, failure: (DioExceptions error) {
        emit(
          state.copyWith(status: AuthStateStatus.unAuthenticated, msg: DioExceptions.getErrorMSg(error)),
        );
      });
    } catch (error) {
      emit(
        state.copyWith(status: AuthStateStatus.unAuthenticated, msg: error.toString()),
      );
    }
  }

  Future<void> _onCheckLogin(CheckLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStateStatus.loading));
      await Future.delayed(Duration.zero);
      String? token = await userBox.get('authToken');
      if (userBox.isEmpty) {
        emit(state.copyWith(status: AuthStateStatus.unAuthenticated));
      } else if (token != null && token != "") {
        emit(state.copyWith(status: AuthStateStatus.authenticated));
      } else {
        emit(state.copyWith(status: AuthStateStatus.unAuthenticated));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStateStatus.failure, msg: e.toString()));
    }
  }

  Future<void> _onForgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStateStatus.sendingMail));
      ApiResult<Response> apiResult = await _userRepository.forgotPassword(
        event.email,
      );
      apiResult.when(success: (Response data) {
        emit(
          state.copyWith(status: AuthStateStatus.sended, msg: data.data['message']),
        );
      }, failure: (DioExceptions error) {
        emit(
          state.copyWith(status: AuthStateStatus.failure, msg: DioExceptions.getErrorMSg(error)),
        );
      });
    } catch (e) {
      emit(state.copyWith(status: AuthStateStatus.failure, msg: e.toString()));
    }
  }

  Future<void> _onConfirmOtp(ConfirmOtpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStateStatus.confirmingOtp));
      ApiResult<Response> apiResult = await _userRepository.confirmOtp(
        event.otp,
      );
      apiResult.when(success: (Response data) {
        emit(
          state.copyWith(status: AuthStateStatus.confirmed, msg: jsonEncode(data.data)),
        );
      }, failure: (DioExceptions error) {
        emit(
          state.copyWith(status: AuthStateStatus.failure, msg: DioExceptions.getErrorMSg(error)),
        );
      });
    } catch (e) {
      emit(state.copyWith(status: AuthStateStatus.failure, msg: e.toString()));
    }
  }

  Future<void> _onChangePassword(ChangePasswordEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStateStatus.updating));
      ApiResult<Response> apiResult =
          await _userRepository.changePassword(event.oldPassword, event.newPassword, event.confirmPassword);
      apiResult.when(success: (Response data) {
        emit(state.copyWith(
          status: AuthStateStatus.updated,
          msg: data.data['message'],
        ));
      }, failure: (DioExceptions error) {
        emit(
          state.copyWith(status: AuthStateStatus.failure, msg: DioExceptions.getErrorMSg(error)),
        );
      });
    } catch (e) {
      emit(state.copyWith(status: AuthStateStatus.failure, msg: e.toString()));
    }
  }

  Future<void> _onResetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStateStatus.updating));
      ApiResult<Response> apiResult =
          await _userRepository.resetPassword(event.email, event.token, event.newPassword, event.confirmPassword);
      apiResult.when(success: (Response data) {
        emit(state.copyWith(
          status: AuthStateStatus.updated,
          msg: data.data['message'],
        ));
      }, failure: (DioExceptions error) {
        emit(
          state.copyWith(status: AuthStateStatus.failure, msg: DioExceptions.getErrorMSg(error)),
        );
      });
    } catch (e) {
      emit(state.copyWith(status: AuthStateStatus.failure, msg: e.toString()));
    }
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStateStatus.loading));
      ApiResult<Response> apiResult = await _userRepository.userLogout();
      apiResult.when(success: (Response data) {
        emit(
          state.copyWith(status: AuthStateStatus.unAuthenticated, msg: data.data['message']),
        );
      }, failure: (DioExceptions error) {
        emit(
          state.copyWith(status: AuthStateStatus.failure, msg: DioExceptions.getErrorMSg(error)),
        );
      });
    } catch (e) {
      emit(state.copyWith(status: AuthStateStatus.failure, msg: e.toString()));
    }
  }

  Future<void> _onTokenExpired(TokenExpiredEvent event, Emitter<AuthState> emit) async {
    emit(
      state.copyWith(status: AuthStateStatus.unAuthenticated),
    );
  }
}
