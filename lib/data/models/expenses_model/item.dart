import 'package:json_annotation/json_annotation.dart';

import 'from_area.dart';
import 'receipt.dart';
import 'to_area.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
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
  @JsonKey(name: 'created_by')
  int? createdBy;
  String? lat;
  String? lng;
  @JsonKey(name: 'recent_comment')
  String? recentComment;

  Item({
    this.id,
    this.userId,
    this.user,
    this.type,
    this.subType,
    this.note,
    this.expenseDate,
    this.amount,
    this.receipts,
    this.placesWorked,
    this.from,
    this.to,
    this.fromArea,
    this.toArea,
    this.distance,
    this.createdBy,
    this.lat,
    this.lng,
    this.recentComment,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
