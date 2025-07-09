import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:bhawsar_chemical/data/models/feedback_model/feedback_model.dart';
import 'package:dio/dio.dart';

import '../dio/api_result.dart';
import '../dio/dio_exception.dart';
import '../models/feedbacks_model/feedbacks_model.dart';

class FeedbackRepository {
  late final DioHelper dioClient;

  FeedbackRepository() {
    final dio = Dio();

    dioClient = DioHelper(baseUrl, dio, interceptors: [
      AuthorizationInterceptor(),
      AddLocationInterceptor(),
    ]);
  }

  Future<ApiResult<FeedbacksModel>> getFeedbacks(int currentPage, int perPageItem) async {
    try {
      String url = "searchCriteria[pageSize]=$perPageItem&searchCriteria[currentPage]=$currentPage&";
      Response response = await dioClient.get('$getFeedbacksUrl/$url');
      return ApiResult.success(FeedbacksModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<FeedbackModel>> getFeedback(int id) async {
    try {
      Response response = await dioClient.get('$getFeedbackUrl$id');
      return ApiResult.success(FeedbackModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  //* user feedback add-update
  Future<ApiResult<Response>> addFeedback(Map<String, dynamic> formData, {String? reqType}) async {
    try {
      String url = reqType == 'post' ? feedbackUrl : '$feedbackUrl/${formData['feedback_id']}';

      Response response = await dioClient.post(
        url,
        data: await formMultiImgData(formData, key: 'attachments'),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  //* delete feedback

  Future<ApiResult<Response>> deleteFeedback(int? id, int? itemIndex) async {
    try {
      Response response = await dioClient.post(deleteFeedbackUrl,
          data: mapToFormData({
            "_method": "DELETE",
            "ids[]": [id]
          }));
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  //* close feedback
  Future<ApiResult<Response>> closeFeedback(int? id, int? itemIndex, String status) async {
    try {
      Response response = await dioClient.post(closeFeedbackUrl,
          data: mapToFormData({
            "_method": "PUT",
            "ids[]": [id],
            "status": status,
          }));
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }
}
