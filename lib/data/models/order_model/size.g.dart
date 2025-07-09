// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Size _$SizeFromJson(Map<String, dynamic> json) => Size(
      productSizeId: (json['product_size_id'] as num?)?.toInt(),
      sizeId: (json['size_id'] as num?)?.toInt(),
      size: json['size'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      scheme: json['scheme'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SizeToJson(Size instance) => <String, dynamic>{
      'product_size_id': instance.productSizeId,
      'size_id': instance.sizeId,
      'size': instance.size,
      'price': instance.price,
      'scheme': instance.scheme,
      'quantity': instance.quantity,
    };
