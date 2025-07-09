import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  int? totalItems;
  int? perPage;
  int? currentPage;
  int? firstPage;
  int? lastPage;

  Meta({
    this.totalItems,
    this.perPage,
    this.currentPage,
    this.firstPage,
    this.lastPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
