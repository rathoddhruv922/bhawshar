import 'dart:io';

import 'package:bhawsar_chemical/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dio_exception.freezed.dart';

@freezed
class DioExceptions with _$DioExceptions {
  static String keyValueSeparator = "->", listSeparator = "|";

  const factory DioExceptions.requestCancelled() = RequestCancelled;

  const factory DioExceptions.unauthorizedRequest(String reason) =
      UnauthorizedRequest;

  const factory DioExceptions.badRequest({String? reason}) = BadRequest;

  const factory DioExceptions.notFound(String reason) = NotFound;

  const factory DioExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory DioExceptions.notAcceptable() = NotAcceptable;

  const factory DioExceptions.requestTimeout() = RequestTimeout;

  const factory DioExceptions.sendTimeout() = SendTimeout;

  const factory DioExceptions.conflict(String reason) = Conflict;

  const factory DioExceptions.internalServerError() = InternalServerError;

  const factory DioExceptions.notImplemented() = NotImplemented;

  const factory DioExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory DioExceptions.noInternetConnection() = NoInternetConnection;

  const factory DioExceptions.formatException() = FormatException;

  const factory DioExceptions.unableToProcess() = UnableToProcess;

  const factory DioExceptions.defaultError(String error) = DefaultError;

  const factory DioExceptions.unexpectedError() = UnexpectedError;

  static getErrorList(Response? response) async {
    String? error;
    try {
      List e = response?.data?['errors'];
      for (Map? item in e) {
        item?.forEach((key, value) {
          if (key == null) {
            error = 'NA$keyValueSeparator$value';
          } else {
            if (error == null) {
              error =
                  '${item['fieldName']}$keyValueSeparator${item['message']}';
            } else {
              error =
                  '$error$listSeparator${item['fieldName']}$keyValueSeparator${item['message']}';
            }
          }
        });
      }

      return error ?? '${response?.data?['message']}';
    } catch (e) {
      if (response == null) {
        error = "custom$keyValueSeparator$InternalServerError";
      } else {
        error = "custom$keyValueSeparator${response.data?['message']}";
      }
      return error;
    }
  }

  static Future<DioExceptions> handleResponse(Response? response) async {
    int statusCode = response?.statusCode ?? 0;
    switch (statusCode) {
      case 400:
        return const DioExceptions.badRequest();
      case 401:
        return DioExceptions.unauthorizedRequest(await getErrorList(response));
      case 403:
        return DioExceptions.unauthorizedRequest(localization.error_403);

      case 404:
        return DioExceptions.notFound(response?.data?['errors'][0]['message'] ??
            response?.data?['message'] ??
            'Requested service cannot be found, or that a requested entity cannot be found!');

      case 409:
        return const DioExceptions.conflict("Error due to conflict");

      case 204:
        return DioExceptions.notFound(
            await getErrorList(response) ?? localization.empty);

      case 422:
        return DioExceptions.conflict(await getErrorList(response));

      case 408:
        return const DioExceptions.requestTimeout();

      case 500:
        return const DioExceptions.internalServerError();

      case 502:
        return DioExceptions.badRequest(reason: await getErrorList(response));

      case 503:
        return const DioExceptions.serviceUnavailable();

      default:
        var responseCode = statusCode;
        return DioExceptions.defaultError(
          "Received invalid status code - $responseCode",
        );
    }
  }

  static Future<DioExceptions> getDioException(error) async {
    if (error is Exception) {
      try {
        DioExceptions networkExceptions;
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = const DioExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const DioExceptions.requestTimeout();
              break;
            case DioExceptionType.unknown:
            case DioExceptionType.connectionError:
              SocketException? socketError = error.error as SocketException?;
              networkExceptions = (error.message?.contains("SocketException") ==
                          true ||
                      error.toString().contains("SocketException") == true)
                  ? (hasConnection && socketError?.message != null)
                      ? DioExceptions.defaultError(socketError!.message)
                      : DioExceptions.noInternetConnection()
                  : DioExceptions.conflict(await getErrorList(error.response));
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const DioExceptions.sendTimeout();
              break;
            case DioExceptionType.badResponse:
              networkExceptions =
                  await DioExceptions.handleResponse(error.response);
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = const DioExceptions.sendTimeout();
              break;

            case DioExceptionType.badCertificate:
              networkExceptions =
                  DioExceptions.conflict(await getErrorList(error.response));
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const DioExceptions.noInternetConnection();
        } else {
          if (error.toString().contains("FormatException")) {
            networkExceptions = DioExceptions.defaultError(
              error.toString().split(':').elementAt(1),
            );
          } else {
            networkExceptions = const DioExceptions.unexpectedError();
          }
        }
        return networkExceptions;
      } on FormatException {
        return const DioExceptions.formatException();
      } catch (e) {
        return const DioExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return const DioExceptions.unableToProcess();
      } else if (error.runtimeType.toString().contains("Type")) {
        return const DioExceptions.formatException();
      } else {
        return const DioExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(DioExceptions networkExceptions) {
    var errorMessage = "";
    networkExceptions.when(notImplemented: () {
      errorMessage = "Not Implemented";
    }, requestCancelled: () {
      errorMessage = "Request cancelled";
    }, internalServerError: () {
      errorMessage = "Internal server error!";
    }, notFound: (String reason) {
      errorMessage = reason;
    }, serviceUnavailable: () {
      errorMessage = "Service unavailable! Try again after sometimes";
    }, methodNotAllowed: () {
      errorMessage = "Method Allowed";
    }, badRequest: (String? reason) {
      errorMessage = reason ?? "Bad request. Will not process the request";
    }, unauthorizedRequest: (String error) {
      errorMessage = error;
    }, unexpectedError: () {
      errorMessage = localization.unknown_error;
    }, requestTimeout: () {
      errorMessage = "Connection request timeout. Please try again";
    }, noInternetConnection: () {
      errorMessage = localization.network_error;
    }, conflict: (String error) {
      errorMessage = error;
    }, sendTimeout: () {
      errorMessage = "Request send timeout! Please try again";
    }, unableToProcess: () {
      errorMessage = "custom$keyValueSeparator${localization.unable_process}";
    }, defaultError: (String error) {
      errorMessage = error;
    }, formatException: () {
      errorMessage = localization.unknown_error;
    }, notAcceptable: () {
      errorMessage = "Not acceptable";
    });
    return errorMessage;
  }

  static String getErrorMSg(DioExceptions errorMsg) {
    try {
      return DioExceptions.getErrorMessage(errorMsg)
          .split(listSeparator)
          .first
          .split(keyValueSeparator)
          .elementAt(1);
    } catch (e) {
      return DioExceptions.getErrorMessage(errorMsg);
    }
  }

  static List<String> getErrorMSgList(DioExceptions errorMsg) {
    try {
      return DioExceptions.getErrorMessage(errorMsg)
          .split(listSeparator)
          .toList();
    } catch (e) {
      return DioExceptions.getErrorMessage(errorMsg) as List<String>;
    }
  }
}
