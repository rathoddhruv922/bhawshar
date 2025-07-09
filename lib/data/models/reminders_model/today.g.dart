// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Today _$TodayFromJson(Map<String, dynamic> json) => Today(
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
      createdBy: (json['created_by'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      createdByName: json['created_by_name'] as String?,
      updatedByName: json['updated_by_name'] as String?,
    );

Map<String, dynamic> _$TodayToJson(Today instance) => <String, dynamic>{
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
      'created_by': instance.createdBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'updated_by': instance.updatedBy,
      'created_by_name': instance.createdByName,
      'updated_by_name': instance.updatedByName,
    };
