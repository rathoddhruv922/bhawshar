// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientSettingModel _$ClientSettingModelFromJson(Map<String, dynamic> json) =>
    ClientSettingModel(
      message: json['message'] as String?,
      settings: json['settings'] == null
          ? null
          : Settings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClientSettingModelToJson(ClientSettingModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'settings': instance.settings,
    };
