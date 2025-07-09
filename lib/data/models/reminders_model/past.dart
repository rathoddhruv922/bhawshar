import 'package:json_annotation/json_annotation.dart';

part 'past.g.dart';

@JsonSerializable()
class Past {
  int? id;
  @JsonKey(name: 'client_id')
  int? clientId;
  String? client;
  @JsonKey(name: 'client_image')
  String? clientImage;
  @JsonKey(name: 'user_id')
  int? userId;
  String? user;
  String? message;
  @JsonKey(name: 'date_time')
  String? dateTime;
  @JsonKey(name: 'reminder_type')
  String? reminderType;
  int? status;
  int? complete;
  @JsonKey(name: 'deleted_at')
  String? deletedAt;
  @JsonKey(name: 'created_by')
  int? createdBy;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  @JsonKey(name: 'updated_by')
  int? updatedBy;
  @JsonKey(name: 'created_by_name')
  String? createdByName;
  @JsonKey(name: 'updated_by_name')
  String? updatedByName;

  Past({
    this.id,
    this.clientId,
    this.client,
    this.clientImage,
    this.userId,
    this.user,
    this.message,
    this.dateTime,
    this.reminderType,
    this.status,
    this.complete,
    this.deletedAt,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.createdByName,
    this.updatedByName,
  });

  factory Past.fromJson(Map<String, dynamic> json) => _$PastFromJson(json);

  Map<String, dynamic> toJson() => _$PastToJson(this);
}
