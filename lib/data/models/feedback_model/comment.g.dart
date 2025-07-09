// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: (json['id'] as num?)?.toInt(),
      message: json['message'] as String?,
      commentTo: (json['comment_to'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      user: json['user'] as String?,
      dateTime: json['date_time'] as String?,
      commentMessage: json['comment_message'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'comment_to': instance.commentTo,
      'user_id': instance.userId,
      'user': instance.user,
      'date_time': instance.dateTime,
      'comment_message': instance.commentMessage,
      'attachments': instance.attachments,
    };
