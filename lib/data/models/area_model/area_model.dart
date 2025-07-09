import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'meta.dart';

part 'area_model.g.dart';

@JsonSerializable()
class AreaModel {
  String? message;
  List<Item>? items;
  Meta? meta;
  bool? success;
  String? status;
  bool? errors;

  AreaModel({
    this.message,
    this.items,
    this.meta,
    this.success,
    this.status,
    this.errors,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return _$AreaModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AreaModelToJson(this);
}
