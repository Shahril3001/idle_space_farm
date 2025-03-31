// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enemy_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnemyAdapter extends TypeAdapter<Enemy> {
  @override
  final int typeId = 5;

  @override
  Enemy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Enemy(
      id: fields[0] as String,
      name: fields[1] as String,
      level: fields[2] as int,
      attackPoints: fields[3] as int,
      defensePoints: fields[4] as int,
      agilityPoints: fields[5] as int,
      hp: fields[6] as int,
      mp: fields[7] as int,
      sp: fields[8] as int,
      abilities: (fields[9] as List).cast<AbilitiesModel>(),
      rarity: fields[10] as String,
      type: fields[11] as String,
      region: fields[12] as String,
      description: fields[13] as String,
      maxHp: fields[14] as int,
      maxMp: fields[15] as int,
      maxSp: fields[16] as int,
      criticalPoint: fields[17] as int,
      currentCooldowns: (fields[18] as Map).cast<String, int>(),
      elementAffinities: (fields[19] as List).cast<ElementType>(),
      statusEffects: (fields[20] as List).cast<StatusEffect>(),
      forcedTarget: fields[21] as dynamic,
      skipNextTurn: fields[22] as bool,
      mindControlled: fields[23] as bool,
      mindController: fields[24] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Enemy obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.attackPoints)
      ..writeByte(4)
      ..write(obj.defensePoints)
      ..writeByte(5)
      ..write(obj.agilityPoints)
      ..writeByte(6)
      ..write(obj.hp)
      ..writeByte(7)
      ..write(obj.mp)
      ..writeByte(8)
      ..write(obj.sp)
      ..writeByte(9)
      ..write(obj.abilities)
      ..writeByte(10)
      ..write(obj.rarity)
      ..writeByte(11)
      ..write(obj.type)
      ..writeByte(12)
      ..write(obj.region)
      ..writeByte(13)
      ..write(obj.description)
      ..writeByte(14)
      ..write(obj.maxHp)
      ..writeByte(15)
      ..write(obj.maxMp)
      ..writeByte(16)
      ..write(obj.maxSp)
      ..writeByte(17)
      ..write(obj.criticalPoint)
      ..writeByte(18)
      ..write(obj.currentCooldowns)
      ..writeByte(19)
      ..write(obj.elementAffinities)
      ..writeByte(20)
      ..write(obj.statusEffects)
      ..writeByte(21)
      ..write(obj.forcedTarget)
      ..writeByte(22)
      ..write(obj.skipNextTurn)
      ..writeByte(23)
      ..write(obj.mindControlled)
      ..writeByte(24)
      ..write(obj.mindController);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnemyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
