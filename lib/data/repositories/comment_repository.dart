import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:dio/dio.dart';

import '../dio/api_result.dart';
import '../dio/dio_exception.dart';

class CommentRepository {
  late final DioHelper dioClient;

  CommentRepository() {
    final dio = Dio();

    dioClient = DioHelper(baseUrl, dio, interceptors: [
      AuthorizationInterceptor(),
      AddLocationInterceptor(),
    ]);
  }

  //* user comment add-update
  Future<ApiResult<Response>> addComment(Map<String, dynamic> formData, {String? reqType}) async {
    try {
      String url = reqType == 'post' ? commentUrl : '$commentUrl/${formData['comment_id']}';
      Response response = await dioClient.post(
        url,
        data: await formMultiImgData(formData, key: 'attachments'),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  //* user comment delete
  Future<ApiResult<Response>> deleteComment(int? id, int? itemIndex) async {
    try {
      Response response = await dioClient.post(
        commentUrl,
        data: mapToFormData(
          {
            "_method": "DELETE",
            "ids[]": [id]
          },
        ),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }
}
