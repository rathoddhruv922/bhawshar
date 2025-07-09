import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:dio/dio.dart';

import '../../helper/app_helper.dart';
import '../../main.dart';

class UserRepository {
  late DioHelper dioClient;

  UserRepository() {
    final dio = Dio();

    dioClient = DioHelper(baseUrl, dio, interceptors: [
      AddLocationInterceptor(),
    ]);
  }

  Future<ApiResult<Response>> userLogin(String email, String password) async {
    try {
      String? fcmToken = await getFcmToken();
      Map<String, dynamic> deviceInfo = await getDeviceInfo();
      Map<String, dynamic> formData = {
        'email': email,
        'password': password,
        'fcm_token': fcmToken,
      };
      if (deviceInfo.isNotEmpty) {
        formData.addAll(deviceInfo);
      }
      if (fcmToken != null) {
        Response response = await dioClient.post(
          loginUrl,
          data: mapToFormData(formData),
        );
        return ApiResult.success(response);
      }
      return const ApiResult.failure(DioExceptions.defaultError('FCM Token is not found! Please try again!'));
    } catch (e) {
      if (e.toString().contains('Location')) {
        return ApiResult.failure(DioExceptions.defaultError(localization.location_permission_request));
      }
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> userLogout() async {
    dioClient = DioHelper(baseUrl, Dio(), interceptors: [
      AuthorizationInterceptor(),
      AddLocationInterceptor(),
    ]);
    try {
      Response response = await dioClient.post(logoutUrl, data: mapToFormData({}));
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> forgotPassword(String email) async {
    dioClient = DioHelper(baseUrl, Dio(), interceptors: [
      AddLocationInterceptor(),
    ]);
    try {
      Response response = await dioClient.post(forgotPasswordUrl,
          data: mapToFormData({
            'email': email,
          }));
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> confirmOtp(String otp) async {
    dioClient = DioHelper(baseUrl, Dio(), interceptors: [
      AddLocationInterceptor(),
    ]);
    try {
      Response response = await dioClient.get("$verifyOtp/$otp");
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> changePassword(String oldPwd, String newPwd, String confirmPwd) async {
    dioClient = DioHelper(baseUrl, Dio(), interceptors: [AddLocationInterceptor(), AuthorizationInterceptor()]);
    try {
      Response response = await dioClient.post(changePasswordUrl,
          data: mapToFormData({
            '_method': 'PUT',
            'old_password': oldPwd,
            'new_password': newPwd,
            'new_password_confirmation': confirmPwd,
          }));
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> resetPassword(String email, String token, String newPwd, String confirmPwd) async {
    dioClient = DioHelper(baseUrl, Dio(), interceptors: [
      AddLocationInterceptor(),
    ]);
    try {
      Response response = await dioClient.post(resetPasswordUrl,
          queryParameters: {
            'email': email,
            'token': token,
          },
          data: mapToFormData({
            '_method': 'POST',
            'new_password': newPwd,
            'new_password_confirmation': confirmPwd,
            'lat': "87.4676",
            "lng": "45.556"
          }));
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }
}
