import 'package:json_annotation/json_annotation.dart';

import 'reminder.dart';

part 'reminder_model.g.dart';

@JsonSerializable()
class ReminderModel {
  String? message;
  Reminder? reminder;
  String? status;
  bool? errors;

  ReminderModel({this.message, this.reminder, this.status, this.errors});

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return _$ReminderModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReminderModelToJson(this);
}
