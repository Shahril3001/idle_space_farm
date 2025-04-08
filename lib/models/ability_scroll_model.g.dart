// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ability_scroll_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbilityScrollAdapter extends TypeAdapter<AbilityScroll> {
  @override
  final int typeId = 19;

  @override
  AbilityScroll read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AbilityScroll(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      iconAsset: fields[3] as String,
      abilityId: fields[4] as String,
      rarity: fields[5] as ScrollRarity,
      allowedTypes: (fields[6] as List).cast<String>(),
      allowedRaces: (fields[7] as List).cast<String>(),
      minLevel: fields[8] as int,
      requiredStats: (fields[9] as Map).cast<String, int>(),
      isConsumable: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AbilityScroll obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.iconAsset)
      ..writeByte(4)
      ..write(obj.abilityId)
      ..writeByte(5)
      ..write(obj.rarity)
      ..writeByte(6)
      ..write(obj.allowedTypes)
      ..writeByte(7)
      ..write(obj.allowedRaces)
      ..writeByte(8)
      ..write(obj.minLevel)
      ..writeByte(9)
      ..write(obj.requiredStats)
      ..writeByte(10)
      ..write(obj.isConsumable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbilityScrollAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScrollRarityAdapter extends TypeAdapter<ScrollRarity> {
  @override
  final int typeId = 20;

  @override
  ScrollRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ScrollRarity.common;
      case 1:
        return ScrollRarity.uncommon;
      case 2:
        return ScrollRarity.rare;
      case 3:
        return ScrollRarity.epic;
      default:
        return ScrollRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, ScrollRarity obj) {
    switch (obj) {
      case ScrollRarity.common:
        writer.writeByte(0);
        break;
      case ScrollRarity.uncommon:
        writer.writeByte(1);
        break;
      case ScrollRarity.rare:
        writer.writeByte(2);
        break;
      case ScrollRarity.epic:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScrollRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
