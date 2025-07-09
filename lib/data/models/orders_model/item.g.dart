// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      notes: json['notes'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      userId: (json['user_id'] as num?)?.toInt(),
      user: json['user'] as String?,
      clientId: (json['client_id'] as num?)?.toInt(),
      client: json['client'] as String?,
      distributorId: (json['distributor_id'] as num?)?.toInt(),
      distributor: json['distributor'] as String?,
      status: json['status'] as String?,
      reminder: (json['reminder'] as num?)?.toInt(),
      inActiveProduct: (json['in_active_product'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdBy: (json['created_by'] as num?)?.toInt(),
      updatedBy: (json['updated_by'] as num?)?.toInt(),
      deletedAt: json['deleted_at'] as String?,
      createdByName: json['created_by_name'] as String?,
      updatedByName: json['updated_by_name'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
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
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'deleted_at': instance.deletedAt,
      'created_by_name': instance.createdByName,
      'updated_by_name': instance.updatedByName,
      'products': instance.products,
    };
