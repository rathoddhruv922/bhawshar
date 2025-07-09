import 'package:json_annotation/json_annotation.dart';

part 'size.g.dart';

@JsonSerializable()
class Size {
  @JsonKey(name: 'product_size_id')
  int? productSizeId;
  @JsonKey(name: 'size_id')
  int? sizeId;
  String? size;
  double? price;
  String? scheme;
  int? quantity;

  Size({
    this.productSizeId,
    this.sizeId,
    this.size,
    this.price,
    this.scheme,
    this.quantity,
  });

  factory Size.fromJson(Map<String, dynamic> json) => _$SizeFromJson(json);

  Map<String, dynamic> toJson() => _$SizeToJson(this);
}
