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
      imageFace: fields[8] as String,
      attackPoints: fields[9] as int,
      defensePoints: fields[10] as int,
      agilityPoints: fields[11] as int,
      hp: fields[12] as int,
      mp: fields[13] as int,
      sp: fields[14] as int,
      abilities: (fields[15] as List).cast<String>(),
      race: fields[16] as String,
      type: fields[17] as String,
      region: fields[18] as String,
      description: fields[19] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GirlFarmer obj) {
    writer
      ..writeByte(20)
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
      ..write(obj.imageFace)
      ..writeByte(9)
      ..write(obj.attackPoints)
      ..writeByte(10)
      ..write(obj.defensePoints)
      ..writeByte(11)
      ..write(obj.agilityPoints)
      ..writeByte(12)
      ..write(obj.hp)
      ..writeByte(13)
      ..write(obj.mp)
      ..writeByte(14)
      ..write(obj.sp)
      ..writeByte(15)
      ..write(obj.abilities)
      ..writeByte(16)
      ..write(obj.race)
      ..writeByte(17)
      ..write(obj.type)
      ..writeByte(18)
      ..write(obj.region)
      ..writeByte(19)
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
