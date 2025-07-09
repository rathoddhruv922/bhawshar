import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'meta.dart';

part 'orders_model.g.dart';

@JsonSerializable()
class OrdersModel {
  String? message;
  List<Item>? items;
  Meta? meta;
  bool? success;
  String? status;
  bool? errors;
  @JsonKey(name: 'open_feedback')
  int? openFeedback;

  OrdersModel({
    this.message,
    this.items,
    this.meta,
    this.success,
    this.status,
    this.errors,
    this.openFeedback,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return _$OrdersModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OrdersModelToJson(this);
}
