import 'package:json_annotation/json_annotation.dart';

import 'image.dart';
import 'size.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int? id;
  String? name;
  String? description;
  String? type;
  List<Image>? images;
  int? configurable;
  String? range;
  List<Size>? sizes;
  int? status;
  int? quantity;
  double? price;
  String? scheme;

  Item({
    this.id,
    this.name,
    this.description,
    this.type,
    this.images,
    this.configurable,
    this.range,
    this.sizes,
    this.status,
    this.quantity,
    this.price,
    this.scheme,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
