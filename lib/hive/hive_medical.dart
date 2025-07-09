import 'package:hive_flutter/adapters.dart';

part 'hive_medical.g.dart';

@HiveType(typeId: 0)
class HiveMedical extends HiveObject {
  HiveMedical(
      {required this.formData,
      required this.imgPath,
      this.error,
      this.isSync = false,
      required this.requestType,
      this.clientId});

  @HiveField(0)
  Map<String, dynamic>? formData;

  @HiveField(1)
  String? imgPath;

  @HiveField(2)
  String? error;

  @HiveField(3)
  bool? isSync;

  @HiveField(4)
  String requestType;

  @HiveField(5)
  int? clientId;
}
