import 'package:json_annotation/json_annotation.dart';

import 'order.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  String? message;
  Order? order;
  String? status;
  bool? errors;

  OrderModel({this.message, this.order, this.status, this.errors});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return _$OrderModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
