import 'package:json_annotation/json_annotation.dart';

import 'expense.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class ExpenseModel {
  String? message;
  Expense? expense;
  String? status;
  bool? errors;

  ExpenseModel({this.message, this.expense, this.status, this.errors});

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return _$ExpenseModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);
}
