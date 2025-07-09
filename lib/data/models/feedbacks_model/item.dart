import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int? id;
  @JsonKey(name: 'user_id')
  int? userId;
  String? user;
  String? type;
  String? description;
  String? status;
  @JsonKey(name: 'comments_count')
  int? commentsCount;
  @JsonKey(name: 'date_time')
  String? dateTime;

  Item({
    this.id,
    this.userId,
    this.user,
    this.type,
    this.description,
    this.status,
    this.commentsCount,
    this.dateTime,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
