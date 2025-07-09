// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminders_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemindersModel _$RemindersModelFromJson(Map<String, dynamic> json) =>
    RemindersModel(
      message: json['message'] as String?,
      pending: (json['pending'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      success: json['success'] as bool?,
      status: json['status'] as String?,
      errors: json['errors'] as bool?,
      openFeedback: (json['open_feedback'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RemindersModelToJson(RemindersModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'pending': instance.pending,
      'items': instance.items,
      'meta': instance.meta,
      'success': instance.success,
      'status': instance.status,
      'errors': instance.errors,
      'open_feedback': instance.openFeedback,
    };
