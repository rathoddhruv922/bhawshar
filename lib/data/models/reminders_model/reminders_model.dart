import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'meta.dart';

part 'reminders_model.g.dart';

@JsonSerializable()
class RemindersModel {
  String? message;
  int? pending;
  List<Item>? items;
  Meta? meta;
  bool? success;
  String? status;
  bool? errors;
  @JsonKey(name: 'open_feedback')
  int? openFeedback;

  RemindersModel({
    this.message,
    this.pending,
    this.items,
    this.meta,
    this.success,
    this.status,
    this.errors,
    this.openFeedback,
  });

  factory RemindersModel.fromJson(Map<String, dynamic> json) {
    return _$RemindersModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RemindersModelToJson(this);
}
