// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_medical.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMedicalAdapter extends TypeAdapter<HiveMedical> {
  @override
  final int typeId = 0;

  @override
  HiveMedical read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMedical(
      formData: (fields[0] as Map?)?.cast<String, dynamic>(),
      imgPath: fields[1] as String?,
      error: fields[2] as String?,
      isSync: fields[3] as bool?,
      requestType: fields[4] as String,
      clientId: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMedical obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.formData)
      ..writeByte(1)
      ..write(obj.imgPath)
      ..writeByte(2)
      ..write(obj.error)
      ..writeByte(3)
      ..write(obj.isSync)
      ..writeByte(4)
      ..write(obj.requestType)
      ..writeByte(5)
      ..write(obj.clientId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMedicalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
