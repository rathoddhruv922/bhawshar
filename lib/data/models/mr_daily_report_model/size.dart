import 'package:json_annotation/json_annotation.dart';

part 'size.g.dart';

@JsonSerializable()
class Size {
  String? size;
  @JsonKey(name: 'total_qty')
  int? totalQty;
  @JsonKey(name: 'product_size_id')
  int? productSizeId;
  @JsonKey(name: 'available_qty')
  int? availableQty;

  Size({this.size, this.totalQty, this.productSizeId,this.availableQty});

  factory Size.fromJson(Map<String, dynamic> json) => _$SizeFromJson(json);

  Map<String, dynamic> toJson() => _$SizeToJson(this);
}
