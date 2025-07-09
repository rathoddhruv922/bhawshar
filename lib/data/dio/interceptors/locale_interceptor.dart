part of 'interceptors.dart';

class LocaleInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String locale = await userBox.get('locale') ?? 'en';
    options.headers['Accept-Language'] = locale;
    return super.onRequest(options, handler);
  }
}
