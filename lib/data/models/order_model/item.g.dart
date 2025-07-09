// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      orderId: (json['order_id'] as num?)?.toInt(),
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      price: (json['price'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toInt(),
      productSizeId: (json['product_size_id'] as num?)?.toInt(),
      size: json['size'] as String?,
      shipQuantity: (json['ship_quantity'] as num?)?.toInt(),
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      name: json['name'] as String?,
      productType: json['product_type'] as String?,
      schemeApplied: (json['scheme_applied'] as num?)?.toInt(),
      scheme: json['scheme'] as String?,
      notIntrested: (json['not_intrested'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'order_id': instance.orderId,
      'product': instance.product,
      'price': instance.price,
      'quantity': instance.quantity,
      'product_size_id': instance.productSizeId,
      'size': instance.size,
      'ship_quantity': instance.shipQuantity,
      'sub_total': instance.subTotal,
      'name': instance.name,
      'product_type': instance.productType,
      'scheme_applied': instance.schemeApplied,
      'scheme': instance.scheme,
      'not_intrested': instance.notIntrested,
    };
