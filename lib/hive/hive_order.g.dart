// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveOrderAdapter extends TypeAdapter<HiveOrder> {
  @override
  final int typeId = 3;

  @override
  HiveOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveOrder(
      formData: (fields[0] as Map?)?.cast<String, dynamic>(),
      error: fields[1] as String?,
      isSync: fields[2] as bool?,
      requestType: fields[3] as String,
      orderData: (fields[4] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveOrder obj) {
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
      ..write(obj.orderData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
