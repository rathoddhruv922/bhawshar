import 'package:json_annotation/json_annotation.dart';

import 'past.dart';
import 'today.dart';
import 'tomorrow.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  List<Today>? today;
  List<Tomorrow>? tomorrow;
  List<Past>? past;

  Item({this.today, this.tomorrow, this.past});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
