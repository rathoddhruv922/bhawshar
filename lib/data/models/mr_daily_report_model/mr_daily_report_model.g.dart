// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mr_daily_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MrDailyReportModel _$MrDailyReportModelFromJson(Map<String, dynamic> json) =>
    MrDailyReportModel(
      loginData: json['loginData'] == null
          ? null
          : LoginData.fromJson(json['loginData'] as Map<String, dynamic>),
      activity: json['activity'] == null
          ? null
          : Activity.fromJson(json['activity'] as Map<String, dynamic>),
      productive: (json['productive'] as List<dynamic>?)
          ?.map((e) => Productive.fromJson(e as Map<String, dynamic>))
          .toList(),
      nonproductive: (json['nonproductive'] as List<dynamic>?)
          ?.map((e) => Nonproductive.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MrDailyReportModelToJson(MrDailyReportModel instance) =>
    <String, dynamic>{
      'loginData': instance.loginData,
      'activity': instance.activity,
      'productive': instance.productive,
      'nonproductive': instance.nonproductive,
      'products': instance.products,
    };
