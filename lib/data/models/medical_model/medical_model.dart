import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'meta.dart';

part 'medical_model.g.dart';

@JsonSerializable()
class MedicalModel {
  String? message;
  List<Item>? items;
  Meta? meta;
  bool? success;
  String? status;
  bool? errors;
  @JsonKey(name: 'open_feedback')
  int? openFeedback;

  MedicalModel({
    this.message,
    this.items,
    this.meta,
    this.success,
    this.status,
    this.errors,
    this.openFeedback,
  });

  factory MedicalModel.fromJson(Map<String, dynamic> json) {
    return _$MedicalModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MedicalModelToJson(this);
}
