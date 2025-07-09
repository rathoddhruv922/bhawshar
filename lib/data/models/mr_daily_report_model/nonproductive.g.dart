// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nonproductive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nonproductive _$NonproductiveFromJson(Map<String, dynamic> json) =>
    Nonproductive(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      notes: json['notes'] as String?,
      total: (json['total'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      user: json['user'] as String?,
      clientId: (json['client_id'] as num?)?.toInt(),
      client: json['client'] as String?,
      distributorId: (json['distributor_id'] as num?)?.toInt(),
      distributor: json['distributor'] as String?,
      status: json['status'] as String?,
      reminder: (json['reminder'] as num?)?.toInt(),
      inActiveProduct: (json['in_active_product'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NonproductiveToJson(Nonproductive instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'notes': instance.notes,
      'total': instance.total,
      'user_id': instance.userId,
      'user': instance.user,
      'client_id': instance.clientId,
      'client': instance.client,
      'distributor_id': instance.distributorId,
      'distributor': instance.distributor,
      'status': instance.status,
      'reminder': instance.reminder,
      'in_active_product': instance.inActiveProduct,
    };
