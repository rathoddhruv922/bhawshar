import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int? id;
  String? name;
  @JsonKey(name: 'state_id')
  int? stateId;
  @JsonKey(name: 'state_name')
  String? stateName;
  int? status;

  Item({this.id, this.name, this.stateId, this.stateName, this.status});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
