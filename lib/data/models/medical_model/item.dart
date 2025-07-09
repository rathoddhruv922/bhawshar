import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  String? name;
  int? id;
  String? email;
  @JsonKey(name: 'area_id')
  int? areaId;
  String? area;
  @JsonKey(name: 'city_id')
  int? cityId;
  String? city;
  @JsonKey(name: 'state_id')
  int? stateId;
  String? state;
  String? image;
  String? type;
  String? phone;
  @JsonKey(name: 'pan_gst')
  String? panGst;
  @JsonKey(name: 'pan_gst_type')
  String? panGstType;
  int? zip;
  String? mobile;
  String? address;
  @JsonKey(name: 'created_by')
  int? createdBy;
  String? notification;
  int? status;
  String? profile;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  @JsonKey(name: 'updated_by')
  int? updatedBy;
  @JsonKey(name: 'deleted_at')
  String? deletedAt;
  @JsonKey(name: 'created_by_name')
  String? createdByName;
  @JsonKey(name: 'updated_by_name')
  String? updatedByName;

  Item({
    this.name,
    this.id,
    this.email,
    this.areaId,
    this.area,
    this.cityId,
    this.city,
    this.stateId,
    this.state,
    this.image,
    this.type,
    this.phone,
    this.panGst,
    this.panGstType,
    this.zip,
    this.mobile,
    this.address,
    this.createdBy,
    this.notification,
    this.status,
    this.profile,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.createdByName,
    this.updatedByName,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
