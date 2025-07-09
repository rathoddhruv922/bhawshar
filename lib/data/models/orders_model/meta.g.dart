// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      totalItems: (json['totalItems'] as num?)?.toInt(),
      perPage: (json['perPage'] as num?)?.toInt(),
      currentPage: (json['currentPage'] as num?)?.toInt(),
      firstPage: (json['firstPage'] as num?)?.toInt(),
      lastPage: (json['lastPage'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'totalItems': instance.totalItems,
      'perPage': instance.perPage,
      'currentPage': instance.currentPage,
      'firstPage': instance.firstPage,
      'lastPage': instance.lastPage,
    };
