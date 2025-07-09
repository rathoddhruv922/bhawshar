import 'package:bhawsar_chemical/data/dio/api_result.dart';
import 'package:bhawsar_chemical/data/dio/dio_exception.dart';
import 'package:bhawsar_chemical/data/models/product_model/product_model.dart';
import 'package:bhawsar_chemical/data/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/enums.dart';
import '../../../helper/app_helper.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  ProductBloc(this.productRepository) : super(const ProductState()) {
    on<SearchProductEvent>(_onSearchProduct,
        transformer: throttleDroppable(const Duration(milliseconds: 400)));
    on<GetProductsEvent>(_onGetProducts,
        transformer: throttleDroppable(const Duration(milliseconds: 400)));
    on<ClearProductEvent>(_onClearProduct);
  }

  Future<void> _onClearProduct(
      ClearProductEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
      status: ProductStatus.initial,
    ));
  }

  Future<void> _onSearchProduct(
      SearchProductEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
      status: ProductStatus.loading,
      res: state.res,
    ));
    try {
      ApiResult<ProductModel> apiResult = await productRepository.searchProduct(
          event.searchKeyword, event.type, event.existingProductIds);
      apiResult.when(success: (ProductModel data) async {
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: ProductStatus.loaded,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          status: ProductStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: ProductStatus.failure,
      ));
    }
  }

  Future<void> _onGetProducts(
      GetProductsEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
      status: ProductStatus.loading,
      res: state.res,
    ));
    try {
      ApiResult<ProductModel> apiResult = await productRepository.getProducts(
          event.type, event.existingProductIds);
      apiResult.when(success: (ProductModel data) async {
        emit(
          state.copyWith(
            res: data,
            msg: data.message,
            status: ProductStatus.loaded,
          ),
        );
      }, failure: (DioExceptions error) async {
        emit(state.copyWith(
          res: state.res,
          status: ProductStatus.failure,
          msg: DioExceptions.getErrorMSg(error),
        ));
      });
    } catch (e) {
      emit(state.copyWith(
        res: state.res,
        msg: (e.toString()),
        status: ProductStatus.failure,
      ));
    }
  }
}
