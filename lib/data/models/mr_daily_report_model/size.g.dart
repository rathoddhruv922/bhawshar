// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Size _$SizeFromJson(Map<String, dynamic> json) => Size(
      size: json['size'] as String?,
      totalQty: (json['total_qty'] as num?)?.toInt(),
      productSizeId: (json['product_size_id'] as num?)?.toInt(),
      availableQty: (json['available_qty'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SizeToJson(Size instance) => <String, dynamic>{
      'size': instance.size,
      'total_qty': instance.totalQty,
      'product_size_id': instance.productSizeId,
      'available_qty': instance.availableQty,
    };
