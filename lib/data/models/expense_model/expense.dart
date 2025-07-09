import 'package:json_annotation/json_annotation.dart';

import 'comment.dart';
import 'from_area.dart';
import 'receipt.dart';
import 'to_area.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense {
  int? id;
  @JsonKey(name: 'user_id')
  int? userId;
  String? user;
  String? type;
  @JsonKey(name: 'sub_type')
  String? subType;
  String? note;
  @JsonKey(name: 'expense_date')
  String? expenseDate;
  double? amount;
  String? status;
  List<Receipt>? receipts;
  @JsonKey(name: 'places_worked')
  String? placesWorked;
  int? from;
  int? to;
  @JsonKey(name: 'from_area')
  FromArea? fromArea;
  @JsonKey(name: 'to_area')
  ToArea? toArea;
  double? distance;
  String? lat;
  String? lng;
  List<Comment>? comments;

  Expense({
    this.id,
    this.userId,
    this.user,
    this.type,
    this.subType,
    this.note,
    this.expenseDate,
    this.amount,
    this.status,
    this.receipts,
    this.placesWorked,
    this.from,
    this.to,
    this.fromArea,
    this.toArea,
    this.distance,
    this.lat,
    this.lng,
    this.comments,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return _$ExpenseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}
