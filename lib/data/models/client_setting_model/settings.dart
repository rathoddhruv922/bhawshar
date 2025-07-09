import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings {
  bool? phone;
  bool? address;
  @JsonKey(name: 'pan_gst')
  bool? panGst;
  bool? zip;
  bool? email;
  bool? name;
  bool? mobile;
  @JsonKey(name: 'open_feedback')
  int? openFeedback;
  @JsonKey(name: 'global_area_access')
  bool? globalAreaAccess;

  Settings({
    this.phone,
    this.address,
    this.panGst,
    this.zip,
    this.email,
    this.name,
    this.mobile,
    this.openFeedback,
    this.globalAreaAccess,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return _$SettingsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
