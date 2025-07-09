import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  int? id;
  String? action;
  String? comment;
  @JsonKey(name: 'expense_id')
  String? expenseId;
  String? user;
  @JsonKey(name: 'user_id')
  int? userId;
  String? role;

  Comment({
    this.id,
    this.action,
    this.comment,
    this.expenseId,
    this.user,
    this.userId,
    this.role,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return _$CommentFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
