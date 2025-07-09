// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      order: (json['Order'] as num?)?.toInt(),
      expense: (json['Expense'] as num?)?.toInt(),
      client: (json['Client'] as num?)?.toInt(),
      reminder: (json['Reminder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'Order': instance.order,
      'Expense': instance.expense,
      'Client': instance.client,
      'Reminder': instance.reminder,
    };
