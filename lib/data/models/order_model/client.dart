import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable()
class Client {
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

  Client({
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
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return _$ClientFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ClientToJson(this);
}
