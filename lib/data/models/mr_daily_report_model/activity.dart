import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity {
  @JsonKey(name: 'Order')
  int? order;
  @JsonKey(name: 'Expense')
  int? expense;
  @JsonKey(name: 'Client')
  int? client;
  @JsonKey(name: 'Reminder')
  int? reminder;

  Activity({this.order, this.expense, this.client, this.reminder});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return _$ActivityFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
