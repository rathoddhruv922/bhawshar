import 'package:json_annotation/json_annotation.dart';

import 'attachment.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  int? id;
  String? message;
  @JsonKey(name: 'comment_to')
  int? commentTo;
  @JsonKey(name: 'user_id')
  int? userId;
  String? user;
  @JsonKey(name: 'date_time')
  String? dateTime;
  @JsonKey(name: 'comment_message')
  String? commentMessage;
  List<Attachment>? attachments;

  Comment({
    this.id,
    this.message,
    this.commentTo,
    this.userId,
    this.user,
    this.dateTime,
    this.commentMessage,
    this.attachments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return _$CommentFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
