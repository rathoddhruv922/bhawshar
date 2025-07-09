import 'package:json_annotation/json_annotation.dart';

import 'activity.dart';
import 'login_data.dart';
import 'nonproductive.dart';
import 'product.dart';
import 'productive.dart';

part 'mr_daily_report_model.g.dart';

@JsonSerializable()
class MrDailyReportModel {
  LoginData? loginData;
  Activity? activity;
  List<Productive>? productive;
  List<Nonproductive>? nonproductive;
  List<Product>? products;

  MrDailyReportModel({
    this.loginData,
    this.activity,
    this.productive,
    this.nonproductive,
    this.products,
  });

  factory MrDailyReportModel.fromJson(Map<String, dynamic> json) {
    return _$MrDailyReportModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MrDailyReportModelToJson(this);
}
