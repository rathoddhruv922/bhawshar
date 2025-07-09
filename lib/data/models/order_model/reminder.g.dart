// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) => Reminder(
      id: (json['id'] as num?)?.toInt(),
      clientId: (json['client_id'] as num?)?.toInt(),
      client: json['client'] as String?,
      clientImage: json['client_image'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      user: json['user'] as String?,
      message: json['message'] as String?,
      dateTime: json['date_time'] as String?,
      reminderType: json['reminder_type'] as String?,
      status: (json['status'] as num?)?.toInt(),
      complete: (json['complete'] as num?)?.toInt(),
      deletedAt: json['deleted_at'] as String?,
    );

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'id': instance.id,
      'client_id': instance.clientId,
      'client': instance.client,
      'client_image': instance.clientImage,
      'user_id': instance.userId,
      'user': instance.user,
      'message': instance.message,
      'date_time': instance.dateTime,
      'reminder_type': instance.reminderType,
      'status': instance.status,
      'complete': instance.complete,
      'deleted_at': instance.deletedAt,
    };
