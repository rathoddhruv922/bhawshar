import 'package:json_annotation/json_annotation.dart';

part 'reminder.g.dart';

@JsonSerializable()
class Reminder {
  int? id;
  @JsonKey(name: 'client_id')
  int? clientId;
  String? client;
  @JsonKey(name: 'client_image')
  String? clientImage;
  @JsonKey(name: 'user_id')
  int? userId;
  String? user;
  String? message;
  @JsonKey(name: 'date_time')
  String? dateTime;
  @JsonKey(name: 'reminder_type')
  String? reminderType;
  int? status;
  int? complete;
  @JsonKey(name: 'deleted_at')
  String? deletedAt;

  Reminder({
    this.id,
    this.clientId,
    this.client,
    this.clientImage,
    this.userId,
    this.user,
    this.message,
    this.dateTime,
    this.reminderType,
    this.status,
    this.complete,
    this.deletedAt,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return _$ReminderFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}
