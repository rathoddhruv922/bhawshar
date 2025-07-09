import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:bhawsar_chemical/data/models/area_model/area_model.dart';
import 'package:bhawsar_chemical/data/models/city_model/city_model.dart';
import 'package:bhawsar_chemical/data/models/state_model/state_model.dart';
import 'package:dio/dio.dart';

class AddressRepository {
  late final DioHelper dioClient;

  AddressRepository() {
    final dio = Dio();

    dioClient = DioHelper(baseUrl, dio,
        interceptors: [AuthorizationInterceptor(), AddLocationInterceptor()]);
  }
  Future<ApiResult<StateModel>> getStateDetail(
      String searchKeyword, bool isAddState) async {
    try {
      String url =
          '$getStateUrl/searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][0][condition_type]=${isAddState ? 'eq' : 'like'}&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1&';

      Response response = await dioClient.get(url);

      return ApiResult.success(StateModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<CityModel>> getCityDetail(
      int? stateId, String cityName, bool isAddCity) async {
    try {
      String url =
          '$getCityUrl/searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=$cityName&searchCriteria[filter_groups][0][filters][0][condition_type]=${isAddCity ? 'eq' : 'like'}&searchCriteria[filter_groups][1][filters][0][field]=state_id&searchCriteria[filter_groups][1][filters][0][value]=$stateId&searchCriteria[filter_groups][1][filters][0][condition_type]=eq&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1&';

      Response response = await dioClient.get(url);
      return ApiResult.success(CityModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<AreaModel>> getAreaDetail(
      int cityId, String areaName, bool isAddArea) async {
    try {
      String url =
          '$getAreaUrl/searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=$areaName&searchCriteria[filter_groups][0][filters][0][condition_type]=${isAddArea ? 'eq' : 'like'}&searchCriteria[filter_groups][1][filters][0][field]=city_id&searchCriteria[filter_groups][1][filters][0][value]=$cityId&searchCriteria[filter_groups][1][filters][0][condition_type]=like&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1&';

      Response response = await dioClient.get(url);

      return ApiResult.success(AreaModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<AreaModel>> getGlobalAreas(
      int? cityId, String areaName) async {
    try {
      String url = cityId != null
          ? '$getAreaUrl/searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=$areaName&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[filter_groups][1][filters][0][field]=city_id&searchCriteria[filter_groups][1][filters][0][value]=$cityId&searchCriteria[filter_groups][1][filters][0][condition_type]=like&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1&'
          : '$getAreaUrl/searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=$areaName&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1';

      Response response = await dioClient.get(url);

      return ApiResult.success(AreaModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }
}
