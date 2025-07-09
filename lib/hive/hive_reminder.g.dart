// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveReminderAdapter extends TypeAdapter<HiveReminder> {
  @override
  final int typeId = 1;

  @override
  HiveReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveReminder(
      formData: (fields[0] as Map?)?.cast<String, dynamic>(),
      error: fields[1] as String?,
      isSync: fields[2] as bool?,
      requestType: fields[3] as String,
      medicalInfo: (fields[4] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveReminder obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.formData)
      ..writeByte(1)
      ..write(obj.error)
      ..writeByte(2)
      ..write(obj.isSync)
      ..writeByte(3)
      ..write(obj.requestType)
      ..writeByte(4)
      ..write(obj.medicalInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
