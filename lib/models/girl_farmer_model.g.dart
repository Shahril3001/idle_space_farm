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
      attackPoints: fields[8] as int,
      defensePoints: fields[9] as int,
      agilityPoints: fields[10] as int,
      hp: fields[11] as int,
      mp: fields[12] as int,
      sp: fields[13] as int,
      abilities: (fields[14] as List).cast<String>(),
      race: fields[15] as String,
      type: fields[16] as String,
      region: fields[17] as String,
      description: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GirlFarmer obj) {
    writer
      ..writeByte(19)
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
      ..write(obj.image)
      ..writeByte(8)
      ..write(obj.attackPoints)
      ..writeByte(9)
      ..write(obj.defensePoints)
      ..writeByte(10)
      ..write(obj.agilityPoints)
      ..writeByte(11)
      ..write(obj.hp)
      ..writeByte(12)
      ..write(obj.mp)
      ..writeByte(13)
      ..write(obj.sp)
      ..writeByte(14)
      ..write(obj.abilities)
      ..writeByte(15)
      ..write(obj.race)
      ..writeByte(16)
      ..write(obj.type)
      ..writeByte(17)
      ..write(obj.region)
      ..writeByte(18)
      ..write(obj.description);
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
