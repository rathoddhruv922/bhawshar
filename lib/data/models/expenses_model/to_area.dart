import 'package:json_annotation/json_annotation.dart';

part 'to_area.g.dart';

@JsonSerializable()
class ToArea {
  int? id;
  String? name;

  ToArea({this.id, this.name});

  factory ToArea.fromJson(Map<String, dynamic> json) {
    return _$ToAreaFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ToAreaToJson(this);
}
