// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      name: json['name'] as String?,
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String?,
      areaId: (json['area_id'] as num?)?.toInt(),
      area: json['area'] as String?,
      cityId: (json['city_id'] as num?)?.toInt(),
      city: json['city'] as String?,
      stateId: (json['state_id'] as num?)?.toInt(),
      state: json['state'] as String?,
      image: json['image'] as String?,
      type: json['type'] as String?,
      phone: json['phone'] as String?,
      panGst: json['pan_gst'] as String?,
      panGstType: json['pan_gst_type'] as String?,
      zip: (json['zip'] as num?)?.toInt(),
      mobile: json['mobile'] as String?,
      address: json['address'] as String?,
      createdBy: (json['created_by'] as num?)?.toInt(),
      notification: json['notification'] as String?,
      status: (json['status'] as num?)?.toInt(),
      profile: json['profile'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      deletedAt: json['deleted_at'] as String?,
      createdByName: json['created_by_name'] as String?,
      updatedByName: json['updated_by_name'] as String?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'email': instance.email,
      'area_id': instance.areaId,
      'area': instance.area,
      'city_id': instance.cityId,
      'city': instance.city,
      'state_id': instance.stateId,
      'state': instance.state,
      'image': instance.image,
      'type': instance.type,
      'phone': instance.phone,
      'pan_gst': instance.panGst,
      'pan_gst_type': instance.panGstType,
      'zip': instance.zip,
      'mobile': instance.mobile,
      'address': instance.address,
      'created_by': instance.createdBy,
      'notification': instance.notification,
      'status': instance.status,
      'profile': instance.profile,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'updated_by': instance.updatedBy,
      'deleted_at': instance.deletedAt,
      'created_by_name': instance.createdByName,
      'updated_by_name': instance.updatedByName,
    };
