// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpensesModel _$ExpensesModelFromJson(Map<String, dynamic> json) =>
    ExpensesModel(
      message: json['message'] as String?,
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
      pendingExpenses: (json['pending_expenses'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExpensesModelToJson(ExpensesModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'items': instance.items,
      'meta': instance.meta,
      'success': instance.success,
      'status': instance.status,
      'errors': instance.errors,
      'open_feedback': instance.openFeedback,
      'pending_expenses': instance.pendingExpenses,
    };
