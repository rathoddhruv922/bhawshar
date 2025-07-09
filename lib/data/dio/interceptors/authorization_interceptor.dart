part of 'interceptors.dart';

//* Request methods GET, PUT, POST, PATCH, DELETE needs access token,
//* which needs to be passed with "Authorization" header as BasicAuth .
class AuthorizationInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        navigationKey.currentContext?.read<AuthBloc>().add(
              TokenExpiredEvent(),
            );
      } catch (e) {
        rethrow;
      }
    }
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String token = await userBox.get('authToken') ?? '';
    debugPrint("AuthToken:-$token");
    String basicAuth = 'Bearer $token';
    if (_needAuthorizationHeader(options)) {
      options.headers['Authorization'] = basicAuth;
    }
    return super.onRequest(options, handler);
  }

  bool _needAuthorizationHeader(RequestOptions options) {
    if (options.method == 'GET' || options.method == 'POST' || options.method == 'PUT' || options.method == 'DELETE') {
      return true;
    } else {
      return false;
    }
  }
}
