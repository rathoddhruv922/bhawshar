import 'package:json_annotation/json_annotation.dart';

part 'receipt.g.dart';

@JsonSerializable()
class Receipt {
  int? id;
  String? url;

  Receipt({this.id, this.url});

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return _$ReceiptFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReceiptToJson(this);
}
