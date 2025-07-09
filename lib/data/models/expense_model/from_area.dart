import 'package:json_annotation/json_annotation.dart';

part 'from_area.g.dart';

@JsonSerializable()
class FromArea {
  int? id;
  String? name;

  FromArea({this.id, this.name});

  factory FromArea.fromJson(Map<String, dynamic> json) {
    return _$FromAreaFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FromAreaToJson(this);
}
