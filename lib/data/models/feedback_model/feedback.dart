import 'package:json_annotation/json_annotation.dart';

import 'attachment.dart';
import 'comment.dart';

part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  int? id;
  @JsonKey(name: 'user_id')
  int? userId;
  String? user;
  String? type;
  String? description;
  String? status;
  List<Attachment>? attachments;
  List<Comment>? comments;
  @JsonKey(name: 'date_time')
  String? dateTime;

  Feedback({
    this.id,
    this.userId,
    this.user,
    this.type,
    this.description,
    this.status,
    this.attachments,
    this.comments,
    this.dateTime,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return _$FeedbackFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FeedbackToJson(this);
}
