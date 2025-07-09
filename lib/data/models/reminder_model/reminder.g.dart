// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) => Reminder(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      clientId: (json['client_id'] as num?)?.toInt(),
      message: json['message'] as String?,
      dateTime: json['date_time'] as String?,
      status: (json['status'] as num?)?.toInt(),
      complete: (json['complete'] as num?)?.toInt(),
      reminderType: json['reminder_type'] as String?,
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'client_id': instance.clientId,
      'message': instance.message,
      'date_time': instance.dateTime,
      'status': instance.status,
      'complete': instance.complete,
      'reminder_type': instance.reminderType,
      'client': instance.client,
    };
