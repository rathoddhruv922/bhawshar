// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      phone: json['phone'] as bool?,
      address: json['address'] as bool?,
      panGst: json['pan_gst'] as bool?,
      zip: json['zip'] as bool?,
      email: json['email'] as bool?,
      name: json['name'] as bool?,
      mobile: json['mobile'] as bool?,
      openFeedback: (json['open_feedback'] as num?)?.toInt(),
      globalAreaAccess: json['global_area_access'] as bool?,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'phone': instance.phone,
      'address': instance.address,
      'pan_gst': instance.panGst,
      'zip': instance.zip,
      'email': instance.email,
      'name': instance.name,
      'mobile': instance.mobile,
      'open_feedback': instance.openFeedback,
      'global_area_access': instance.globalAreaAccess,
    };
