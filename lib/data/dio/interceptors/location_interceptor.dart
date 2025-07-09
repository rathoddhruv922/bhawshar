part of 'interceptors.dart';

//* Request methods GET, PUT, POST, PATCH, DELETE needs access token,
//* which needs to be passed with "Authorization" header as BasicAuth .
class AddLocationInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_needLocationData(options)) {
      try {
        // Get the current location
        Position location = await determinePosition(options.path == "/location" ? true : false);
        String? fieldOfWork = await userInfo.value['field_of_work'] ?? 'MKT';
        fieldOfWork ??= 'MKT';
        Map<String, dynamic>? locationData = {
          "lat": location.latitude,
          "lng": location.longitude,
          "field_of_work": ((fieldOfWork == 'WFH') ? 'WFH' : 'MKT'),
        };
        locationData.forEach((key, value) {
          if (options.path == "/order") {
            options.data.fields.add(MapEntry("order[$key]", value.toString()));
          } else {
            options.data.fields.add(MapEntry(key, value.toString()));
          }
        });
        super.onRequest(options, handler);
      } catch (e) {
        if (options.path == "/location") {
          options.data.fields.add(const MapEntry("lat", "-0.0"));
          options.data.fields.add(const MapEntry("lng", "-0.0"));
          showCatchedError(localization.location_enabled);
        }
        if (options.path == "/order") {
          options.data.fields.add(const MapEntry("order[lat]", "-0.0"));
          options.data.fields.add(const MapEntry("order[lng]", "-0.0"));
          showCatchedError(localization.location_enabled);
        }
        handler.reject(
          DioException.sendTimeout(
            timeout: Duration.zero,
            requestOptions: options,
          ),
        );
      }
    } else {
      super.onRequest(options, handler);
    }
  }

  bool _needLocationData(RequestOptions options) {
    if ((options.method == 'POST' || options.method == 'PUT' || options.method == 'DELETE')) {
      bool isLatLngPass = true;
      try {
        //* return false because request has already add location (for offline data)
        options.data.fields.forEach((e) {
          if (e.key == 'lat') {
            isLatLngPass = false;
          }
        });
      } catch (e) {
        showCatchedError(e);
      }
      return isLatLngPass;
    } else {
      return false;
    }
  }
}
