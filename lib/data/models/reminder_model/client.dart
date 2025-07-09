import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable()
class Client {
  int? id;
  String? name;
  String? image;
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
  String? type;
  String? phone;
  String? gst;
  int? zip;
  String? mobile;
  String? address;
  int? status;
  int? complete;

  Client({
    this.id,
    this.name,
    this.image,
    this.email,
    this.areaId,
    this.area,
    this.cityId,
    this.city,
    this.stateId,
    this.state,
    this.type,
    this.phone,
    this.gst,
    this.zip,
    this.mobile,
    this.address,
    this.status,
    this.complete,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return _$ClientFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ClientToJson(this);
}
