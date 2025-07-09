// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      notes: json['notes'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      userId: (json['user_id'] as num?)?.toInt(),
      clientId: (json['client_id'] as num?)?.toInt(),
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      distributor: json['distributor'] == null
          ? null
          : Distributor.fromJson(json['distributor'] as Map<String, dynamic>),
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      inActiveProduct: (json['in_active_product'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      reminder: json['reminder'] == null
          ? null
          : Reminder.fromJson(json['reminder'] as Map<String, dynamic>),
      nonIntrestedItems: (json['non_intrested_items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      notIntrested: (json['not_intrested'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'notes': instance.notes,
      'total': instance.total,
      'user_id': instance.userId,
      'client_id': instance.clientId,
      'client': instance.client,
      'distributor': instance.distributor,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'in_active_product': instance.inActiveProduct,
      'items': instance.items,
      'non_intrested_items': instance.nonIntrestedItems,
      'not_intrested': instance.notIntrested,
      'reminder': instance.reminder,
    };
