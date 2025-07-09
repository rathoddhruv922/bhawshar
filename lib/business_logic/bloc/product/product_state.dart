part of 'product_bloc.dart';

class ProductState extends Equatable {
  const ProductState({this.status = ProductStatus.initial, this.res, this.msg});

  final String? msg;
  final dynamic res;
  final ProductStatus status;

  @override
  List<Object?> get props => [status, msg, res];

  ProductState copyWith({dynamic res, String? msg, ProductStatus? status}) {
    return ProductState(
        res: status == ProductStatus.initial ? null : res ?? this.res,
        msg: msg ?? this.msg,
        status: status ?? this.status);
  }
}
