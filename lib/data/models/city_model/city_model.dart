import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'meta.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel {
  String? message;
  List<Item>? items;
  Meta? meta;
  bool? success;
  String? status;
  bool? errors;

  CityModel({
    this.message,
    this.items,
    this.meta,
    this.success,
    this.status,
    this.errors,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return _$CityModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}
