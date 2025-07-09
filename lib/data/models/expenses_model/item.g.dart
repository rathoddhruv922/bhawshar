// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      user: json['user'] as String?,
      type: json['type'] as String?,
      subType: json['sub_type'] as String?,
      note: json['note'] as String?,
      expenseDate: json['expense_date'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      receipts: (json['receipts'] as List<dynamic>?)
          ?.map((e) => Receipt.fromJson(e as Map<String, dynamic>))
          .toList(),
      placesWorked: json['places_worked'] as String?,
      from: (json['from'] as num?)?.toInt(),
      to: (json['to'] as num?)?.toInt(),
      fromArea: json['from_area'] == null
          ? null
          : FromArea.fromJson(json['from_area'] as Map<String, dynamic>),
      toArea: json['to_area'] == null
          ? null
          : ToArea.fromJson(json['to_area'] as Map<String, dynamic>),
      distance: (json['distance'] as num?)?.toDouble(),
      createdBy: (json['created_by'] as num?)?.toInt(),
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
      recentComment: json['recent_comment'] as String?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'user': instance.user,
      'type': instance.type,
      'sub_type': instance.subType,
      'note': instance.note,
      'expense_date': instance.expenseDate,
      'amount': instance.amount,
      'receipts': instance.receipts,
      'places_worked': instance.placesWorked,
      'from': instance.from,
      'to': instance.to,
      'from_area': instance.fromArea,
      'to_area': instance.toArea,
      'distance': instance.distance,
      'created_by': instance.createdBy,
      'lat': instance.lat,
      'lng': instance.lng,
      'recent_comment': instance.recentComment,
    };
