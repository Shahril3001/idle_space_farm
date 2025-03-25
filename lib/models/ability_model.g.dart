// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ability_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbilitiesModelAdapter extends TypeAdapter<AbilitiesModel> {
  @override
  final int typeId = 6;

  @override
  AbilitiesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AbilitiesModel(
      abilitiesID: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      attackBonus: fields[3] as int,
      defenseBonus: fields[4] as int,
      hpBonus: fields[5] as int,
      agilityBonus: fields[6] as int,
      mpCost: fields[7] as int,
      spCost: fields[8] as int,
      cooldown: fields[9] as int,
      criticalPoint: fields[10] as int,
    )..cooldownTimer = fields[11] as int;
  }

  @override
  void write(BinaryWriter writer, AbilitiesModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.abilitiesID)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.attackBonus)
      ..writeByte(4)
      ..write(obj.defenseBonus)
      ..writeByte(5)
      ..write(obj.hpBonus)
      ..writeByte(6)
      ..write(obj.agilityBonus)
      ..writeByte(7)
      ..write(obj.mpCost)
      ..writeByte(8)
      ..write(obj.spCost)
      ..writeByte(9)
      ..write(obj.cooldown)
      ..writeByte(10)
      ..write(obj.criticalPoint)
      ..writeByte(11)
      ..write(obj.cooldownTimer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbilitiesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
