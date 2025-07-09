import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'meta.dart';

part 'state_model.g.dart';

@JsonSerializable()
class StateModel {
  String? message;
  List<Item>? items;
  Meta? meta;
  bool? success;
  String? status;
  bool? errors;

  StateModel({
    this.message,
    this.items,
    this.meta,
    this.success,
    this.status,
    this.errors,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return _$StateModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StateModelToJson(this);
}
