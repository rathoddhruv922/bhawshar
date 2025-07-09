part of 'product_bloc.dart';

class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class SearchProductEvent extends ProductEvent {
  final String searchKeyword, type;
  final List<int> existingProductIds;

  const SearchProductEvent(
      {required this.searchKeyword,
      required this.type,
      required this.existingProductIds});

  @override
  List<Object> get props => [searchKeyword, type, existingProductIds];
}

class GetProductsEvent extends ProductEvent {
  final String type;
  final List<int> existingProductIds;

  const GetProductsEvent(
      {required this.type, required this.existingProductIds});

  @override
  List<Object> get props => [type, existingProductIds];
}

class ClearProductEvent extends ProductEvent {
  const ClearProductEvent();

  @override
  List<Object> get props => [];
}
