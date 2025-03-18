// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FloorAdapter extends TypeAdapter<Floor> {
  @override
  final int typeId = 4;

  @override
  Floor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Floor(
      id: fields[0] as String,
      level: fields[1] as int,
      isUnlocked: fields[2] as bool,
      assignedGirlId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Floor obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.isUnlocked)
      ..writeByte(3)
      ..write(obj.assignedGirlId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FloorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
