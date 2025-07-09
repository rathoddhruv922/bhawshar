import 'package:json_annotation/json_annotation.dart';

import 'size.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  int? id;
  String? name;
  String? description;
  String? type;
  int? configurable;
  List<Size>? sizes;
  int? quantity;
  double? price;
  String? scheme;
  int? status;

  Product({
    this.id,
    this.name,
    this.description,
    this.type,
    this.configurable,
    this.sizes,
    this.quantity,
    this.price,
    this.scheme,
    this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
