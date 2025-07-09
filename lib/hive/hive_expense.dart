import 'package:hive_flutter/adapters.dart';

part 'hive_expense.g.dart';

@HiveType(typeId: 2)
class HiveExpense extends HiveObject {
  HiveExpense({
    required this.formData,
    this.error,
    this.isSync = false,
    required this.requestType,
  });

  @HiveField(0)
  Map<String, dynamic>? formData;

  @HiveField(1)
  String? error;

  @HiveField(2)
  bool? isSync;

  @HiveField(3)
  String requestType;
}
