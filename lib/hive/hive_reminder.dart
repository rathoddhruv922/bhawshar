import 'package:hive_flutter/adapters.dart';

part 'hive_reminder.g.dart';

@HiveType(typeId: 1)
class HiveReminder extends HiveObject {
  HiveReminder(
      {required this.formData,
      this.error,
      this.isSync = false,
      required this.requestType,
      required this.medicalInfo});

  @HiveField(0)
  Map<String, dynamic>? formData;

  @HiveField(1)
  String? error;

  @HiveField(2)
  bool? isSync;

  @HiveField(3)
  String requestType;

  @HiveField(4)
  Map<String, dynamic> medicalInfo;
}
