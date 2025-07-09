import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:bhawsar_chemical/data/models/mr_daily_report_model/mr_daily_report_model.dart';
import 'package:dio/dio.dart';

class ReportRepository {
  late final DioHelper dioClient;

  ReportRepository() {
    final dio = Dio();

    dioClient =
        DioHelper(baseUrl, dio, interceptors: [AuthorizationInterceptor()]);
  }

  Future<ApiResult<MrDailyReportModel>> getReport(DateTime date) async {
    try {
      String url = '$getDailyReport/${date.year}/${date.month}/${date.day}';

      Response response = await dioClient.get(url);

      return ApiResult.success(MrDailyReportModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }
}
