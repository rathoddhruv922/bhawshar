import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  @JsonKey(name: 'order_id')
  int? orderId;
  Product? product;
  double? price;
  int? quantity;
  @JsonKey(name: 'product_size_id')
  int? productSizeId;
  String? size;
  @JsonKey(name: 'ship_quantity')
  int? shipQuantity;
  @JsonKey(name: 'sub_total')
  double? subTotal;
  String? name;
  @JsonKey(name: 'product_type')
  String? productType;
  @JsonKey(name: 'scheme_applied')
  int? schemeApplied;
  String? scheme;
  @JsonKey(name: 'not_intrested')
  int? notIntrested;

  Item({
    this.orderId,
    this.product,
    this.price,
    this.quantity,
    this.productSizeId,
    this.size,
    this.shipQuantity,
    this.subTotal,
    this.name,
    this.productType,
    this.schemeApplied,
    this.scheme,
    this.notIntrested,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
