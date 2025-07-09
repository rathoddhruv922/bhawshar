// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_expense.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveExpenseAdapter extends TypeAdapter<HiveExpense> {
  @override
  final int typeId = 2;

  @override
  HiveExpense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveExpense(
      formData: (fields[0] as Map?)?.cast<String, dynamic>(),
      error: fields[1] as String?,
      isSync: fields[2] as bool?,
      requestType: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveExpense obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.formData)
      ..writeByte(1)
      ..write(obj.error)
      ..writeByte(2)
      ..write(obj.isSync)
      ..writeByte(3)
      ..write(obj.requestType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
