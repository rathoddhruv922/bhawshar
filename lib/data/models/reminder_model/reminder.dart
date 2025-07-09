import 'package:json_annotation/json_annotation.dart';

import 'client.dart';

part 'reminder.g.dart';

@JsonSerializable()
class Reminder {
  int? id;
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'client_id')
  int? clientId;
  String? message;
  @JsonKey(name: 'date_time')
  String? dateTime;
  int? status;
  int? complete;
  @JsonKey(name: 'reminder_type')
  String? reminderType;
  Client? client;

  Reminder({
    this.id,
    this.userId,
    this.clientId,
    this.message,
    this.dateTime,
    this.status,
    this.complete,
    this.reminderType,
    this.client,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return _$ReminderFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}
