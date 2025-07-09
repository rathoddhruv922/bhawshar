import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:bhawsar_chemical/helper/app_helper.dart';
import 'package:bhawsar_chemical/main.dart';
import 'package:bhawsar_chemical/src/router/route_list.dart';
import 'package:bhawsar_chemical/utils/location_singleton.dart';
import 'package:dio/dio.dart';

class LocationRepository {
  late final DioHelper dioClient;

  LocationRepository() {
    final dio = Dio();

    dioClient = DioHelper(baseUrl, dio, interceptors: [
      AuthorizationInterceptor(),
      AddLocationInterceptor(),
    ]);
  }

  Future<Response> sendCurrentLocation() async {
    Response response = Response(requestOptions: RequestOptions());
    try {
      String? fieldOfWork = await userInfo.value['field_of_work'] ?? 'MKT';
      fieldOfWork ??= 'MKT';
      int action = LocationState().myBool;
      response = await dioClient.post(
        sendLocationUrl,
        data: mapToFormData({
          "field_of_work": fieldOfWork,
          "action": action == -1
              ? null
              : action == 1
                  ? "Start"
                  : "Stop"
        }),
      );
      return response;
    } on DioException catch (e) {
      LocationState().myBool = -1;
      if (e.response?.statusCode == 401) {
        await updateTrackingStatus(0);
        navigationKey.currentState?.pushReplacementNamed(RouteList.login);
      }
      return response = Response<dynamic>(requestOptions: RequestOptions(), statusCode: 401, data: {});
    } catch (e) {
      String error = DioExceptions.getErrorMSg(await DioExceptions.getDioException(e));
      if (error.toString().contains('re-login') == true) {
        //! Force disabled tracking because token is expired
        await updateTrackingStatus(0);
        LocationState().myBool = -1;
        response = Response<dynamic>(requestOptions: RequestOptions(), statusCode: 401, data: {});
      }
      return response;
    }
  }
}
