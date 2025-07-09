import 'package:json_annotation/json_annotation.dart';

import 'size.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  String? name;
  List<Size>? sizes;
  String? size;
  @JsonKey(name: 'total_qty')
  int? totalQty;
  @JsonKey(name: 'product_size_id')
  int? productSizeId;
  @JsonKey(name: 'available_qty')
  int? availableQty;

  Product({
    this.name,
    this.sizes,
    this.size,
    this.totalQty,
    this.productSizeId,
    this.availableQty
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
