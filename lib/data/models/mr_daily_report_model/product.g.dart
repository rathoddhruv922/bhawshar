// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      name: json['name'] as String?,
      sizes: (json['sizes'] as List<dynamic>?)
          ?.map((e) => Size.fromJson(e as Map<String, dynamic>))
          .toList(),
      size: json['size'] as String?,
      totalQty: (json['total_qty'] as num?)?.toInt(),
      productSizeId: (json['product_size_id'] as num?)?.toInt(),
      availableQty: (json['available_qty'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'name': instance.name,
      'sizes': instance.sizes,
      'size': instance.size,
      'total_qty': instance.totalQty,
      'product_size_id': instance.productSizeId,
      'available_qty': instance.availableQty,
    };
