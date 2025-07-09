// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: (json['id'] as num?)?.toInt(),
      action: json['action'] as String?,
      comment: json['comment'] as String?,
      expenseId: json['expense_id'] as String?,
      user: json['user'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      role: json['role'] as String?,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'comment': instance.comment,
      'expense_id': instance.expenseId,
      'user': instance.user,
      'user_id': instance.userId,
      'role': instance.role,
    };
