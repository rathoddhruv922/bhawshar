// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      today: (json['today'] as List<dynamic>?)
          ?.map((e) => Today.fromJson(e as Map<String, dynamic>))
          .toList(),
      tomorrow: (json['tomorrow'] as List<dynamic>?)
          ?.map((e) => Tomorrow.fromJson(e as Map<String, dynamic>))
          .toList(),
      past: (json['past'] as List<dynamic>?)
          ?.map((e) => Past.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'today': instance.today,
      'tomorrow': instance.tomorrow,
      'past': instance.past,
    };
