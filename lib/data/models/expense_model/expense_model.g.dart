// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) => ExpenseModel(
      message: json['message'] as String?,
      expense: json['expense'] == null
          ? null
          : Expense.fromJson(json['expense'] as Map<String, dynamic>),
      status: json['status'] as String?,
      errors: json['errors'] as bool?,
    );

Map<String, dynamic> _$ExpenseModelToJson(ExpenseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'expense': instance.expense,
      'status': instance.status,
      'errors': instance.errors,
    };
