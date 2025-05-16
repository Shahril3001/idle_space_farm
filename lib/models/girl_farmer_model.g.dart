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
      abilities: (fields[15] as List).cast<AbilitiesModel>(),
      race: fields[16] as String,
      type: fields[17] as String,
      region: fields[18] as String,
      description: fields[19] as String,
      maxHp: fields[20] as int,
      maxMp: fields[21] as int,
      maxSp: fields[22] as int,
      criticalPoint: fields[23] as int,
      elementAffinities: (fields[25] as List).cast<ElementType>(),
      statusEffects: (fields[26] as List).cast<StatusEffect>(),
      forcedTarget: fields[27] as dynamic,
      skipNextTurn: fields[28] as bool,
      mindControlled: fields[29] as bool,
      mindController: fields[30] as dynamic,
      partyMemberIds: (fields[31] as List).cast<String>(),
      isUntargetable: fields[32] as bool,
      equippedItems: (fields[33] as List).cast<Equipment>(),
    ).._cooldownsStorage = (fields[24] as Map).cast<String, int>();
  }

  @override
  void write(BinaryWriter writer, GirlFarmer obj) {
    writer
      ..writeByte(34)
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
      ..write(obj.description)
      ..writeByte(20)
      ..write(obj.maxHp)
      ..writeByte(21)
      ..write(obj.maxMp)
      ..writeByte(22)
      ..write(obj.maxSp)
      ..writeByte(23)
      ..write(obj.criticalPoint)
      ..writeByte(24)
      ..write(obj._cooldownsStorage)
      ..writeByte(25)
      ..write(obj.elementAffinities)
      ..writeByte(26)
      ..write(obj.statusEffects)
      ..writeByte(27)
      ..write(obj.forcedTarget)
      ..writeByte(28)
      ..write(obj.skipNextTurn)
      ..writeByte(29)
      ..write(obj.mindControlled)
      ..writeByte(30)
      ..write(obj.mindController)
      ..writeByte(31)
      ..write(obj.partyMemberIds)
      ..writeByte(32)
      ..write(obj.isUntargetable)
      ..writeByte(33)
      ..write(obj.equippedItems);
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

class CharacterTypeAdapter extends TypeAdapter<CharacterType> {
  @override
  final int typeId = 28;

  @override
  CharacterType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CharacterType.warrior;
      case 1:
        return CharacterType.archmage;
      case 2:
        return CharacterType.assassin;
      case 3:
        return CharacterType.cleric;
      case 4:
        return CharacterType.paladin;
      case 5:
        return CharacterType.elementalist;
      case 6:
        return CharacterType.berserker;
      case 7:
        return CharacterType.archer;
      case 8:
        return CharacterType.unknown;
      default:
        return CharacterType.warrior;
    }
  }

  @override
  void write(BinaryWriter writer, CharacterType obj) {
    switch (obj) {
      case CharacterType.warrior:
        writer.writeByte(0);
        break;
      case CharacterType.archmage:
        writer.writeByte(1);
        break;
      case CharacterType.assassin:
        writer.writeByte(2);
        break;
      case CharacterType.cleric:
        writer.writeByte(3);
        break;
      case CharacterType.paladin:
        writer.writeByte(4);
        break;
      case CharacterType.elementalist:
        writer.writeByte(5);
        break;
      case CharacterType.berserker:
        writer.writeByte(6);
        break;
      case CharacterType.archer:
        writer.writeByte(7);
        break;
      case CharacterType.unknown:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CharacterRaceAdapter extends TypeAdapter<CharacterRace> {
  @override
  final int typeId = 29;

  @override
  CharacterRace read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CharacterRace.human;
      case 1:
        return CharacterRace.elves;
      case 2:
        return CharacterRace.daemon;
      case 3:
        return CharacterRace.beastkin;
      case 4:
        return CharacterRace.dragonkin;
      case 5:
        return CharacterRace.celestial;
      case 6:
        return CharacterRace.unknown;
      default:
        return CharacterRace.human;
    }
  }

  @override
  void write(BinaryWriter writer, CharacterRace obj) {
    switch (obj) {
      case CharacterRace.human:
        writer.writeByte(0);
        break;
      case CharacterRace.elves:
        writer.writeByte(1);
        break;
      case CharacterRace.daemon:
        writer.writeByte(2);
        break;
      case CharacterRace.beastkin:
        writer.writeByte(3);
        break;
      case CharacterRace.dragonkin:
        writer.writeByte(4);
        break;
      case CharacterRace.celestial:
        writer.writeByte(5);
        break;
      case CharacterRace.unknown:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterRaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
