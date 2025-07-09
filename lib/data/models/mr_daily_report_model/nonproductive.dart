import 'package:json_annotation/json_annotation.dart';

part 'nonproductive.g.dart';

@JsonSerializable()
class Nonproductive {
  int? id;
  String? type;
  String? notes;
  int? total;
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

  Nonproductive({
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

  factory Nonproductive.fromJson(Map<String, dynamic> json) {
    return _$NonproductiveFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NonproductiveToJson(this);
}
