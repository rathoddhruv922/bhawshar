import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int? id;
  String? type;
  String? notes;
  double? total;
  @JsonKey(name: 'user_id')
  int? userId;
  String? user;
  @JsonKey(name: 'client_id')
  int? clientId;
  String? client;
  @JsonKey(name: 'distributor_id')
  int? distributorId;
  String? distributor;
  String? status;
  int? reminder;
  @JsonKey(name: 'in_active_product')
  int? inActiveProduct;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  @JsonKey(name: 'created_by')
  int? createdBy;
  @JsonKey(name: 'updated_by')
  int? updatedBy;
  @JsonKey(name: 'deleted_at')
  String? deletedAt;
  @JsonKey(name: 'created_by_name')
  String? createdByName;
  @JsonKey(name: 'updated_by_name')
  String? updatedByName;
  List<Product>? products;

  Item({
    this.id,
    this.type,
    this.notes,
    this.total,
    this.userId,
    this.user,
    this.clientId,
    this.client,
    this.distributorId,
    this.distributor,
    this.status,
    this.reminder,
    this.inActiveProduct,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.createdByName,
    this.updatedByName,
    this.products,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
