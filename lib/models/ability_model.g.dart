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
      type: fields[12] as AbilityType,
      targetType: fields[13] as TargetType,
      affectsEnemies: fields[14] as bool,
    )..cooldownTimer = fields[11] as int;
  }

  @override
  void write(BinaryWriter writer, AbilitiesModel obj) {
    writer
      ..writeByte(15)
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
      ..write(obj.cooldownTimer)
      ..writeByte(12)
      ..write(obj.type)
      ..writeByte(13)
      ..write(obj.targetType)
      ..writeByte(14)
      ..write(obj.affectsEnemies);
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

class AbilityTypeAdapter extends TypeAdapter<AbilityType> {
  @override
  final int typeId = 7;

  @override
  AbilityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AbilityType.attack;
      case 1:
        return AbilityType.heal;
      case 2:
        return AbilityType.buff;
      case 3:
        return AbilityType.debuff;
      default:
        return AbilityType.attack;
    }
  }

  @override
  void write(BinaryWriter writer, AbilityType obj) {
    switch (obj) {
      case AbilityType.attack:
        writer.writeByte(0);
        break;
      case AbilityType.heal:
        writer.writeByte(1);
        break;
      case AbilityType.buff:
        writer.writeByte(2);
        break;
      case AbilityType.debuff:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbilityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TargetTypeAdapter extends TypeAdapter<TargetType> {
  @override
  final int typeId = 8;

  @override
  TargetType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TargetType.single;
      case 1:
        return TargetType.all;
      default:
        return TargetType.single;
    }
  }

  @override
  void write(BinaryWriter writer, TargetType obj) {
    switch (obj) {
      case TargetType.single:
        writer.writeByte(0);
        break;
      case TargetType.all:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TargetTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
