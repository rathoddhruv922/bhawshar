import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int? id;
  String? name;
  int? status;

  Item({this.id, this.name, this.status});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
