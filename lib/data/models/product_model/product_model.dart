import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'meta.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  String? message;
  List<Item>? items;
  Meta? meta;
  bool? success;
  String? status;
  bool? errors;

  ProductModel({
    this.message,
    this.items,
    this.meta,
    this.success,
    this.status,
    this.errors,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return _$ProductModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
