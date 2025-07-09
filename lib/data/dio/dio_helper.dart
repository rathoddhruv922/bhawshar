import 'dart:convert';
import 'dart:io';

import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../helper/app_helper.dart';
import '../../main.dart';

const Duration _defaultReceiveTimeout = Duration(seconds: 120);
const Duration _defaultConnectTimeout = Duration(seconds: 120);
const Duration _defaultSendTimeout = Duration(seconds: 120);

class DioHelper {
  //* Dio settings
  final String baseUrl;

  late Dio _dio;

  final List<Interceptor>? interceptors;

  DioHelper(
    this.baseUrl,
    Dio? dio, {
    this.interceptors,
  }) {
    _dio = dio ?? Dio();
    _dio
      ..options.baseUrl = baseUrl
      ..options.sendTimeout = _defaultSendTimeout
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..options.validateStatus
      ..options.contentType = 'application/json; charset=UTF-8;'
      ..options.responseType = ResponseType.json
      ..options.headers;

    _dio.interceptors.addAll(
      isDebugMode
          ? [
              PrettyDioLogger(
                requestHeader: true,
                requestBody: true,
                responseBody: true,
                responseHeader: false,
                error: true,
                compact: false,
                maxWidth: 90,
              ),
              LocaleInterceptor(),
            ]
          : [
              LocaleInterceptor(),
            ],
    );

    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors!);
    }
  }

  //* end Dio settings

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await Future.delayed(Duration.zero);
      Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.data != null && response.data != "" && response.statusCode != 204) {
        return response;
      } else {
        var res = Response<dynamic>(
            requestOptions: RequestOptions(path: response.requestOptions.path),
            statusCode: 204,
            statusMessage: response.statusMessage,
            isRedirect: true,
            data: noDataFoundRes());
        var dioError = DioException(
          requestOptions: RequestOptions(
            path: response.requestOptions.path,
          ),
          type: DioExceptionType.badResponse,
          response: res,
        );
        throw dioError;
      }
    } on SocketException catch (_) {
      showCatchedError(localization.network_error);
      throw SocketException(localization.network_error);
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await Future.delayed(Duration.zero);
      Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.data != null && response.data != "" && response.statusCode != 204) {
        return response;
      } else {
        var res = Response<dynamic>(
          requestOptions: RequestOptions(path: response.requestOptions.path),
          statusCode: 204,
          statusMessage: response.statusMessage,
          isRedirect: true,
          data: noDataFoundRes(),
        );
        var dioError = DioException(
          requestOptions: RequestOptions(path: response.requestOptions.path),
          type: DioExceptionType.badResponse,
          response: res,
        );
        throw dioError;
      }
    } on SocketException catch (_) {
      showCatchedError(localization.network_error);
      throw SocketException(localization.network_error);
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await Future.delayed(Duration.zero);
      Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.data != null && response.data != "" && response.statusCode != 204) {
        return response;
      } else {
        var res = Response<dynamic>(
            requestOptions: RequestOptions(path: response.requestOptions.path),
            statusCode: 204,
            statusMessage: response.statusMessage,
            isRedirect: false,
            data: noDataFoundRes());
        var dioError = DioException(
          requestOptions: RequestOptions(
            path: response.requestOptions.path,
          ),
          type: DioExceptionType.badResponse,
          response: res,
        );
        throw dioError;
      }
    } on SocketException catch (_) {
      showCatchedError(localization.network_error);
      throw SocketException(localization.network_error);
    } on FormatException catch (_) {
      throw const FormatException();
    } catch (e) {
      rethrow;
    }
  }
}

noDataFoundRes() {
  return {
    "message": localization.empty,
    "errors": [
      {"message": localization.empty, "fieldName": "custom"}
    ],
    "code": 204
  };
}

Future<FormData> formMultiImgData(Map<String, dynamic> formData, {String? key}) async {
  try {
    FormData formDataObj = FormData.fromMap(formData, ListFormat.multiCompatible);
    if (formData[key] != null && formData[key] != 'NA') {
      var temp = formData[key];
      formData.removeWhere((k, value) => (k == key));
      await Future.delayed(const Duration(seconds: 1));
      for (int i = 0; i < temp.length; i++) {
        var path = temp[i];
        formDataObj.files.addAll([
          MapEntry("$key[$i]", await MultipartFile.fromFile(path!)),
        ]);
      }
    }
    return formDataObj;
  } catch (e) {
    rethrow;
  }
}

Future<FormData> formImgData(Map<String, dynamic> formData, String imgPath, {String? key}) async {
  try {
    FormData formDataObj = FormData.fromMap(formData, ListFormat.multiCompatible);
    if (imgPath != 'NA' && imgPath.contains(docLink) == false) {
      formDataObj.files.add(
        MapEntry(
          key ?? 'image',
          await MultipartFile.fromFile(
            imgPath,
          ),
        ),
      );
    }
    return formDataObj;
  } catch (e) {
    rethrow;
  }
}

FormData mapToFormData(Map<String, dynamic> formData, {requestAsFormData = false}) {
  try {
    print(jsonEncode(formData));
    FormData formDataObj = FormData.fromMap(formData);
    return formDataObj;
  } catch (e) {
    rethrow;
  }
}
