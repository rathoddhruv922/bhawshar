import 'package:json_annotation/json_annotation.dart';

import 'feedback.dart';

part 'feedback_model.g.dart';

@JsonSerializable()
class FeedbackModel {
  String? message;
  Feedback? feedback;
  String? status;
  bool? errors;

  FeedbackModel({this.message, this.feedback, this.status, this.errors});

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return _$FeedbackModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FeedbackModelToJson(this);
}
