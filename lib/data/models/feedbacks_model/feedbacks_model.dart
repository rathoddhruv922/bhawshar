import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'meta.dart';

part 'feedbacks_model.g.dart';

@JsonSerializable()
class FeedbacksModel {
  String? message;
  List<Item>? items;
  Meta? meta;
  bool? success;
  String? status;
  bool? errors;
  @JsonKey(name: 'open_feedback')
  int? openFeedback;

  FeedbacksModel({
    this.message,
    this.items,
    this.meta,
    this.success,
    this.status,
    this.errors,
    this.openFeedback,
  });

  factory FeedbacksModel.fromJson(Map<String, dynamic> json) {
    return _$FeedbacksModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FeedbacksModelToJson(this);
}
