// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'potion_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PotionAdapter extends TypeAdapter<Potion> {
  @override
  final int typeId = 21;

  @override
  Potion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Potion(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      iconAsset: fields[3] as String,
      maxStack: fields[4] as int,
      hpIncrease: fields[5] as int,
      mpIncrease: fields[6] as int,
      spIncrease: fields[7] as int,
      attackIncrease: fields[8] as int,
      defenseIncrease: fields[9] as int,
      agilityIncrease: fields[10] as int,
      criticalPointIncrease: fields[11] as int,
      rarity: fields[12] as PotionRarity,
      allowedTypes: (fields[13] as List).cast<String>(),
      quantity: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Potion obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.iconAsset)
      ..writeByte(4)
      ..write(obj.maxStack)
      ..writeByte(5)
      ..write(obj.hpIncrease)
      ..writeByte(6)
      ..write(obj.mpIncrease)
      ..writeByte(7)
      ..write(obj.spIncrease)
      ..writeByte(8)
      ..write(obj.attackIncrease)
      ..writeByte(9)
      ..write(obj.defenseIncrease)
      ..writeByte(10)
      ..write(obj.agilityIncrease)
      ..writeByte(11)
      ..write(obj.criticalPointIncrease)
      ..writeByte(12)
      ..write(obj.rarity)
      ..writeByte(13)
      ..write(obj.allowedTypes)
      ..writeByte(14)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PotionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PotionRarityAdapter extends TypeAdapter<PotionRarity> {
  @override
  final int typeId = 22;

  @override
  PotionRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PotionRarity.common;
      case 1:
        return PotionRarity.uncommon;
      case 2:
        return PotionRarity.rare;
      case 3:
        return PotionRarity.epic;
      case 4:
        return PotionRarity.legendary;
      default:
        return PotionRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, PotionRarity obj) {
    switch (obj) {
      case PotionRarity.common:
        writer.writeByte(0);
        break;
      case PotionRarity.uncommon:
        writer.writeByte(1);
        break;
      case PotionRarity.rare:
        writer.writeByte(2);
        break;
      case PotionRarity.epic:
        writer.writeByte(3);
        break;
      case PotionRarity.legendary:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PotionRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
