import 'package:json_annotation/json_annotation.dart';

part 'productive.g.dart';

@JsonSerializable()
class Productive {
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

  Productive({
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
  });

  factory Productive.fromJson(Map<String, dynamic> json) {
    return _$ProductiveFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductiveToJson(this);
}
