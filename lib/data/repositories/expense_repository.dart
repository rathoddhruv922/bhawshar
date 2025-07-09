import 'package:bhawsar_chemical/constants/app_const.dart';
import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/dio/dio_helper.dart';
import 'package:bhawsar_chemical/data/dio/interceptors/interceptors.dart';
import 'package:bhawsar_chemical/data/models/expense_model/expense_model.dart';
import 'package:bhawsar_chemical/data/models/expenses_model/expenses_model.dart';
import 'package:dio/dio.dart';

class ExpenseRepository {
  late final DioHelper dioClient;

  ExpenseRepository() {
    final dio = Dio();

    dioClient = DioHelper(baseUrl, dio, interceptors: [
      AuthorizationInterceptor(),
      AddLocationInterceptor(),
    ]);
  }

  Future<ApiResult<ExpensesModel>> getExpenses(int currentPage, int perPageItem) async {
    try {
      String url = "searchCriteria[pageSize]=$perPageItem&searchCriteria[currentPage]=$currentPage&";
      Response response = await dioClient.get('$getExpensesUrl/$url');
      return ApiResult.success(ExpensesModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ExpenseModel>> getExpenseById(int id) async {
    try {
      Response response = await dioClient.get('$getExpenseUrl$id');
      return ApiResult.success(ExpenseModel.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> addExpenseDetail(Map<String, dynamic> formData, {String? reqType}) async {
    try {
      String url = reqType == 'post' ? addExpenseUrl : '$updateExpenseUrl${formData['expense_id']}';
      Response response = await dioClient.post(
        url,
        data: await formMultiImgData(formData, key: 'receipts'),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> addCommentToExpense(Map<String, dynamic> formData, {String? reqType}) async {
    try {
      String url = addCommentToExpenseUrl;
      Response response = await dioClient.post(
        url,
        data: mapToFormData(formData),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(await DioExceptions.getDioException(e));
    }
  }

  Future<ApiResult<Response>> deleteExpense(int? id, int? itemIndex) async {
    try {
      Response response = await dioClient.post(
        deleteExpenseUrl,
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
