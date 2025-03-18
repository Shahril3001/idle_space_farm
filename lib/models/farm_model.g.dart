// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FarmAdapter extends TypeAdapter<Farm> {
  @override
  final int typeId = 1;

  @override
  Farm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Farm(
      name: fields[0] as String,
      resourcePerSecond: fields[1] as double,
      level: fields[2] as int,
      unlockCost: fields[3] as double,
      maxLevel: fields[4] as int,
      resourceType: fields[5] as String,
      upgradeCost: fields[6] as double,
      floors: (fields[7] as List?)?.cast<Floor>(),
    )..positionData = (fields[8] as List).cast<double>();
  }

  @override
  void write(BinaryWriter writer, Farm obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.resourcePerSecond)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.unlockCost)
      ..writeByte(4)
      ..write(obj.maxLevel)
      ..writeByte(5)
      ..write(obj.resourceType)
      ..writeByte(6)
      ..write(obj.upgradeCost)
      ..writeByte(7)
      ..write(obj.floors)
      ..writeByte(8)
      ..write(obj.positionData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
