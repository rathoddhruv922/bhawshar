import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:bhawsar_chemical/data/models/client_setting_model/client_setting_model.dart';
import 'package:bhawsar_chemical/data/models/medical_model/medical_model.dart';
import 'package:dio/dio.dart';

class MedicalRepository {
  late final DioHelper dioClient;

  MedicalRepository() {
    final dio = Dio();

    dioClient = DioHelper(baseUrl, dio, interceptors: [
      AuthorizationInterceptor(),
      AddLocationInterceptor(),
    ]);
  }

  Future<ApiResult<MedicalModel>> getMedicalDetail(String? searchKeyword,
      {String? type}) async {
    String? url = type == null || type == ''
        ? ("searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[filter_groups][0][filters][1][field]=email&searchCriteria[filter_groups][0][filters][1][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][1][condition_type]=like&searchCriteria[filter_groups][0][filters][2][field]=mobile&searchCriteria[filter_groups][0][filters][2][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][2][condition_type]=like&searchCriteria[filter_groups][0][filters][3][field]=pan_gst&searchCriteria[filter_groups][0][filters][3][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][3][condition_type]=like&searchCriteria[pageSize]=20&searchCriteria[currentPage]=1&searchCriteria[filter_groups][1][filters][0][field]=type&searchCriteria[filter_groups][1][filters][0][value]=MR&searchCriteria[filter_groups][1][filters][0][condition_type]=neq")
        : (type == ("Medical,Doctor,Distributor"))
            ? ("searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[filter_groups][0][filters][1][field]=email&searchCriteria[filter_groups][0][filters][1][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][1][condition_type]=like&searchCriteria[filter_groups][0][filters][2][field]=mobile&searchCriteria[filter_groups][0][filters][2][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][2][condition_type]=like&searchCriteria[filter_groups][0][filters][3][field]=pan_gst&searchCriteria[filter_groups][0][filters][3][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][3][condition_type]=like&searchCriteria[filter_groups][1][filters][0][field]=type&searchCriteria[filter_groups][1][filters][0][value]=$type&searchCriteria[filter_groups][1][filters][0][condition_type]=in&searchCriteria[pageSize]=20&searchCriteria[currentPage]=1")
            : ("searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[filter_groups][0][filters][1][field]=email&searchCriteria[filter_groups][0][filters][1][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][1][condition_type]=like&searchCriteria[filter_groups][0][filters][2][field]=mobile&searchCriteria[filter_groups][0][filters][2][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][2][condition_type]=like&searchCriteria[filter_groups][0][filters][3][field]=pan_gst&searchCriteria[filter_groups][0][filters][3][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][3][condition_type]=like&searchCriteria[filter_groups][1][filters][0][field]=type&searchCriteria[filter_groups][1][filters][0][value]=$type&searchCriteria[filter_groups][1][filters][0][condition_type]=eq&searchCriteria[pageSize]=20&searchCriteria[currentPage]=1");
    try {
      Response response = await dioClient.get('$getMedicalUrl/$url');
      return ApiResult.success(MedicalModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> addMedicalDetail(
      Map<String, dynamic> formData, String imgPath,
      {String? reqType, int? clientId}) async {
    try {
      String url =
          reqType == 'post' ? addMedicalUrl : '$updateMedicalUrl$clientId';

      Response response = await dioClient.post(
        url,
        data: await formImgData(formData, imgPath, key: 'image'),
      );

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ClientSettingModel>> getClientSettings() async {
    try {
      Response response = await dioClient.get(getClientSetting);
      return ApiResult.success(ClientSettingModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }
}
