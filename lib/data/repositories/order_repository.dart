import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:dio/dio.dart';

import '../models/order_model/order_model.dart';
import '../models/orders_model/orders_model.dart';

class OrderRepository {
  late final DioHelper dioClient;

  OrderRepository() {
    final dio = Dio();

    dioClient = DioHelper(baseUrl, dio, interceptors: [
      AuthorizationInterceptor(),
      AddLocationInterceptor(),
    ]);
  }

  Future<ApiResult<OrdersModel>> getOrders(int? currentPage, int? perPageItem, {String? orderType}) async {
    try {
      String url = orderType == 'MR'
          ? "searchCriteria[pageSize]=$perPageItem&searchCriteria[currentPage]=$currentPage&searchCriteria[filter_groups][0][filters][0][field]=type&searchCriteria[filter_groups][0][filters][0][value]=$orderType&searchCriteria[filter_groups][0][filters][0][condition_type]=eq"
          : "searchCriteria[pageSize]=$perPageItem&searchCriteria[currentPage]=$currentPage&searchCriteria[filter_groups][0][filters][0][field]=type&searchCriteria[filter_groups][0][filters][0][value]=At Shop,On Phone&searchCriteria[filter_groups][0][filters][0][condition_type]=in";
      Response response = await dioClient.get('$getOrdersUrl/$url');
      return ApiResult.success(OrdersModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<OrderModel>> getOrder(int id) async {
    try {
      Response response = await dioClient.get('$getOrderUrl$id');
      return ApiResult.success(OrderModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> addOrderDetail(Map<String, dynamic> formData, {String? reqType}) async {
    try {
      String url = reqType == 'post' ? addOrderUrl : '$updateOrderUrl${formData["order"]['order_id']}';
      Response response = await dioClient.post(
        url,
        data: mapToFormData(formData),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> deleteOrder(int? id, int? itemIndex) async {
    try {
      Response response = await dioClient.post(
        deleteOrderUrl,
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

  Future<ApiResult<Response>> cancelOrder(int? id, int? itemIndex, String status) async {
    try {
      Response response = await dioClient.post(cancelOrderUrl,
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
