// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'girl_farmer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GirlFarmerAdapter extends TypeAdapter<GirlFarmer> {
  @override
  final int typeId = 2;

  @override
  GirlFarmer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GirlFarmer(
      id: fields[0] as String,
      name: fields[1] as String,
      level: fields[2] as int,
      miningEfficiency: fields[3] as double,
      assignedFarm: fields[4] as String?,
      rarity: fields[5] as String,
      stars: fields[6] as int,
      image: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GirlFarmer obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.miningEfficiency)
      ..writeByte(4)
      ..write(obj.assignedFarm)
      ..writeByte(5)
      ..write(obj.rarity)
      ..writeByte(6)
      ..write(obj.stars)
      ..writeByte(7)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GirlFarmerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
