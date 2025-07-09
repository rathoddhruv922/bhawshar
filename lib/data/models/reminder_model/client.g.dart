// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      email: json['email'] as String?,
      areaId: (json['area_id'] as num?)?.toInt(),
      area: json['area'] as String?,
      cityId: (json['city_id'] as num?)?.toInt(),
      city: json['city'] as String?,
      stateId: (json['state_id'] as num?)?.toInt(),
      state: json['state'] as String?,
      type: json['type'] as String?,
      phone: json['phone'] as String?,
      gst: json['gst'] as String?,
      zip: (json['zip'] as num?)?.toInt(),
      mobile: json['mobile'] as String?,
      address: json['address'] as String?,
      status: (json['status'] as num?)?.toInt(),
      complete: (json['complete'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'email': instance.email,
      'area_id': instance.areaId,
      'area': instance.area,
      'city_id': instance.cityId,
      'city': instance.city,
      'state_id': instance.stateId,
      'state': instance.state,
      'type': instance.type,
      'phone': instance.phone,
      'gst': instance.gst,
      'zip': instance.zip,
      'mobile': instance.mobile,
      'address': instance.address,
      'status': instance.status,
      'complete': instance.complete,
    };
