import 'package:json_annotation/json_annotation.dart';

import 'item.dart';
import 'meta.dart';

part 'expenses_model.g.dart';

@JsonSerializable()
class ExpensesModel {
  String? message;
  List<Item>? items;
  Meta? meta;
  bool? success;
  String? status;
  bool? errors;
  @JsonKey(name: 'open_feedback')
  int? openFeedback;
  @JsonKey(name: 'pending_expenses')
  int? pendingExpenses;

  ExpensesModel({
    this.message,
    this.items,
    this.meta,
    this.success,
    this.status,
    this.errors,
    this.openFeedback,
    this.pendingExpenses,
  });

  factory ExpensesModel.fromJson(Map<String, dynamic> json) {
    return _$ExpensesModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExpensesModelToJson(this);
}
