import 'package:json_annotation/json_annotation.dart';

import 'settings.dart';

part 'client_setting_model.g.dart';

@JsonSerializable()
class ClientSettingModel {
  String? message;
  Settings? settings;

  ClientSettingModel({this.message, this.settings});

  factory ClientSettingModel.fromJson(Map<String, dynamic> json) {
    return _$ClientSettingModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ClientSettingModelToJson(this);
}
