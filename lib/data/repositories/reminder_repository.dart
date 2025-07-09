import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:bhawsar_chemical/data/models/reminder_model/reminder_model.dart';
import 'package:bhawsar_chemical/data/models/reminders_model/reminders_model.dart';
import 'package:dio/dio.dart';

class ReminderRepository {
  late final DioHelper dioClient;

  ReminderRepository() {
    final dio = Dio();

    dioClient = DioHelper(baseUrl, dio, interceptors: [
      AuthorizationInterceptor(),
      AddLocationInterceptor(),
    ]);
  }

  Future<ApiResult<RemindersModel>> getReminders(int currentPage, int perPageItem) async {
    try {
      String url = "searchCriteria[pageSize]=$perPageItem&searchCriteria[currentPage]=$currentPage&";
      Response response = await dioClient.get('$getRemindersUrl/$url');
      return ApiResult.success(RemindersModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ReminderModel>> getReminder(int id) async {
    try {
      Response response = await dioClient.get('$getReminderUrl$id');
      return ApiResult.success(ReminderModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> deleteReminder(int? id, int? itemIndex) async {
    try {
      Response response = await dioClient.post(
        deleteReminderUrl,
        data: mapToFormData({
          "ids[]": [id],
          "_method": "DELETE",
        }),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> changeReminderStatus(int? id, int? itemIndex, int? complete) async {
    try {
      Response response = await dioClient.post(
        changedReminderStatusUrl,
        data: mapToFormData({
          "complete": complete == 0 ? 1 : 0,
          "ids[]": [id],
          "_method": "PUT",
        }),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> addReminderDetail(Map<String, dynamic> formData, Map<String, dynamic> medicalInfo,
      {String? reqType}) async {
    try {
      String url = reqType == 'post' ? addReminderUrl : '$updateReminderUrl${formData['reminder_id']}';
      Response response = reqType == 'post'
          ? await dioClient.post(url, data: mapToFormData(formData))
          : await dioClient.post(url, data: mapToFormData(formData));
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }
}
