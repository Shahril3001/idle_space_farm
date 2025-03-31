// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ability_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatusEffectAdapter extends TypeAdapter<StatusEffect> {
  @override
  final int typeId = 9;

  @override
  StatusEffect read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatusEffect(
      id: fields[0] as String,
      name: fields[1] as String,
      duration: fields[2] as int,
      damagePerTurn: fields[3] as int,
      attackModifier: fields[4] as int,
      defenseModifier: fields[5] as int,
      agilityModifier: fields[6] as int,
      cooldownRateModifier: fields[7] as double,
      controlEffect: fields[8] as ControlEffect?,
    )..remainingTurns = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, StatusEffect obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.damagePerTurn)
      ..writeByte(4)
      ..write(obj.attackModifier)
      ..writeByte(5)
      ..write(obj.defenseModifier)
      ..writeByte(6)
      ..write(obj.agilityModifier)
      ..writeByte(7)
      ..write(obj.cooldownRateModifier)
      ..writeByte(8)
      ..write(obj.controlEffect)
      ..writeByte(9)
      ..write(obj.remainingTurns);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusEffectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ControlEffectAdapter extends TypeAdapter<ControlEffect> {
  @override
  final int typeId = 10;

  @override
  ControlEffect read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ControlEffect(
      type: fields[0] as ControlEffectType,
      duration: fields[1] as int,
      successChance: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ControlEffect obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.successChance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ControlEffectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      healsCaster: fields[15] as bool,
      healCasterAmount: fields[16] as int,
      drainsHealth: fields[17] as bool,
      statusEffects: (fields[18] as List).cast<StatusEffect>(),
      reducesCooldowns: fields[19] as bool,
      cooldownReductionAmount: fields[20] as int,
      cooldownReductionPercent: fields[21] as double,
      affectsAllCooldowns: fields[22] as bool,
      elementType: fields[23] as ElementType,
      mentalPotency: fields[24] as int,
    )..cooldownTimer = fields[11] as int;
  }

  @override
  void write(BinaryWriter writer, AbilitiesModel obj) {
    writer
      ..writeByte(25)
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
      ..write(obj.affectsEnemies)
      ..writeByte(15)
      ..write(obj.healsCaster)
      ..writeByte(16)
      ..write(obj.healCasterAmount)
      ..writeByte(17)
      ..write(obj.drainsHealth)
      ..writeByte(18)
      ..write(obj.statusEffects)
      ..writeByte(19)
      ..write(obj.reducesCooldowns)
      ..writeByte(20)
      ..write(obj.cooldownReductionAmount)
      ..writeByte(21)
      ..write(obj.cooldownReductionPercent)
      ..writeByte(22)
      ..write(obj.affectsAllCooldowns)
      ..writeByte(23)
      ..write(obj.elementType)
      ..writeByte(24)
      ..write(obj.mentalPotency);
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

class ControlEffectTypeAdapter extends TypeAdapter<ControlEffectType> {
  @override
  final int typeId = 11;

  @override
  ControlEffectType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ControlEffectType.taunt;
      case 1:
        return ControlEffectType.seduce;
      case 2:
        return ControlEffectType.mindControl;
      case 3:
        return ControlEffectType.fear;
      case 4:
        return ControlEffectType.charm;
      default:
        return ControlEffectType.taunt;
    }
  }

  @override
  void write(BinaryWriter writer, ControlEffectType obj) {
    switch (obj) {
      case ControlEffectType.taunt:
        writer.writeByte(0);
        break;
      case ControlEffectType.seduce:
        writer.writeByte(1);
        break;
      case ControlEffectType.mindControl:
        writer.writeByte(2);
        break;
      case ControlEffectType.fear:
        writer.writeByte(3);
        break;
      case ControlEffectType.charm:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ControlEffectTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ElementTypeAdapter extends TypeAdapter<ElementType> {
  @override
  final int typeId = 12;

  @override
  ElementType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ElementType.none;
      case 1:
        return ElementType.fire;
      case 2:
        return ElementType.water;
      case 3:
        return ElementType.earth;
      case 4:
        return ElementType.wind;
      case 5:
        return ElementType.thunder;
      case 6:
        return ElementType.snow;
      case 7:
        return ElementType.nature;
      case 8:
        return ElementType.dark;
      case 9:
        return ElementType.light;
      case 10:
        return ElementType.poison;
      case 11:
        return ElementType.divine;
      default:
        return ElementType.none;
    }
  }

  @override
  void write(BinaryWriter writer, ElementType obj) {
    switch (obj) {
      case ElementType.none:
        writer.writeByte(0);
        break;
      case ElementType.fire:
        writer.writeByte(1);
        break;
      case ElementType.water:
        writer.writeByte(2);
        break;
      case ElementType.earth:
        writer.writeByte(3);
        break;
      case ElementType.wind:
        writer.writeByte(4);
        break;
      case ElementType.thunder:
        writer.writeByte(5);
        break;
      case ElementType.snow:
        writer.writeByte(6);
        break;
      case ElementType.nature:
        writer.writeByte(7);
        break;
      case ElementType.dark:
        writer.writeByte(8);
        break;
      case ElementType.light:
        writer.writeByte(9);
        break;
      case ElementType.poison:
        writer.writeByte(10);
        break;
      case ElementType.divine:
        writer.writeByte(11);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ElementTypeAdapter &&
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
      case 4:
        return AbilityType.control;
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
      case AbilityType.control:
        writer.writeByte(4);
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
