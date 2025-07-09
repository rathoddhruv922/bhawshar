import 'package:json_annotation/json_annotation.dart';

import 'client.dart';
import 'distributor.dart';
import 'item.dart';
import 'reminder.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  int? id;
  String? type;
  String? notes;
  double? total;
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'client_id')
  int? clientId;
  Client? client;
  Distributor? distributor;
  String? status;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'in_active_product')
  int? inActiveProduct;
  List<Item>? items;
  @JsonKey(name: 'non_intrested_items')
  List<Item>? nonIntrestedItems;
  @JsonKey(name: 'not_intrested')
  int? notIntrested;
  Reminder? reminder;

  Order({
    this.id,
    this.type,
    this.notes,
    this.total,
    this.userId,
    this.clientId,
    this.client,
    this.distributor,
    this.status,
    this.createdAt,
    this.inActiveProduct,
    this.items,
    this.reminder,
    this.nonIntrestedItems,
    this.notIntrested,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
