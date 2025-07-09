import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:bhawsar_chemical/data/models/product_model/product_model.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  late final DioHelper dioClient;

  ProductRepository() {
    final dio = Dio();

    dioClient = DioHelper(baseUrl, dio, interceptors: [
      AuthorizationInterceptor(),
      AddLocationInterceptor(),
    ]);
  }

  Future<ApiResult<ProductModel>> searchProduct(
      String? searchKeyword, String type, List<int> existingProductIds) async {
    try {
      String idsAsString =
          existingProductIds.map((e) => e.toString()).join(', ');
      String url =
          "searchCriteria[pageSize]=100&searchCriteria[currentPage]=1&searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=$searchKeyword&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[filter_groups][1][filters][0][field]=type&searchCriteria[filter_groups][1][filters][0][value]=$type&searchCriteria[filter_groups][1][filters][0][condition_type]=eq&searchCriteria[filter_groups][2][filters][0][field]=id&searchCriteria[filter_groups][2][filters][0][value]=$idsAsString&searchCriteria[filter_groups][2][filters][0][condition_type]=nin";
      Response response = await dioClient.get('$getProductsUrl/$url');
      return ApiResult.success(ProductModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ProductModel>> getProducts(
      String type, List<int> existingProductIds) async {
    try {
      String idsAsString =
          existingProductIds.map((e) => e.toString()).join(', ');
      String url =
          "searchCriteria[pageSize]=100&searchCriteria[currentPage]=1&searchCriteria[filter_groups][0][filters][0][field]=type&searchCriteria[filter_groups][0][filters][0][value]=$type&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[filter_groups][1][filters][0][field]=id&searchCriteria[filter_groups][1][filters][0][value]=$idsAsString&searchCriteria[filter_groups][1][filters][0][condition_type]=nin";
      Response response = await dioClient.get('$getProductsUrl/$url');
      return ApiResult.success(ProductModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }
}
