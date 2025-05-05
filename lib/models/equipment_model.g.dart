// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EquipmentAdapter extends TypeAdapter<Equipment> {
  @override
  final int typeId = 13;

  @override
  Equipment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Equipment(
      id: fields[0] as String,
      name: fields[1] as String,
      slot: fields[2] as EquipmentSlot,
      rarity: fields[8] as EquipmentRarity,
      imageEquip: fields[19] as String?,
      weaponType: fields[16] as WeaponType?,
      armorType: fields[17] as ArmorType?,
      accessoryType: fields[18] as AccessoryType?,
      attackBonus: fields[3] as int,
      defenseBonus: fields[4] as int,
      hpBonus: fields[5] as int,
      agilityBonus: fields[6] as int,
      enhancementLevel: fields[7] as int,
      allowedTypes: (fields[9] as List).cast<String>(),
      allowedRaces: (fields[10] as List).cast<String>(),
      isTradable: fields[11] as bool,
      mpBonus: fields[12] as int,
      spBonus: fields[13] as int,
      criticalPoint: fields[14] as int,
      assignedTo: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Equipment obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slot)
      ..writeByte(3)
      ..write(obj.attackBonus)
      ..writeByte(4)
      ..write(obj.defenseBonus)
      ..writeByte(5)
      ..write(obj.hpBonus)
      ..writeByte(6)
      ..write(obj.agilityBonus)
      ..writeByte(7)
      ..write(obj.enhancementLevel)
      ..writeByte(8)
      ..write(obj.rarity)
      ..writeByte(9)
      ..write(obj.allowedTypes)
      ..writeByte(10)
      ..write(obj.allowedRaces)
      ..writeByte(11)
      ..write(obj.isTradable)
      ..writeByte(12)
      ..write(obj.mpBonus)
      ..writeByte(13)
      ..write(obj.spBonus)
      ..writeByte(14)
      ..write(obj.criticalPoint)
      ..writeByte(15)
      ..write(obj.assignedTo)
      ..writeByte(16)
      ..write(obj.weaponType)
      ..writeByte(17)
      ..write(obj.armorType)
      ..writeByte(18)
      ..write(obj.accessoryType)
      ..writeByte(19)
      ..write(obj.imageEquip);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EquipmentRarityAdapter extends TypeAdapter<EquipmentRarity> {
  @override
  final int typeId = 14;

  @override
  EquipmentRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EquipmentRarity.common;
      case 1:
        return EquipmentRarity.uncommon;
      case 2:
        return EquipmentRarity.rare;
      case 3:
        return EquipmentRarity.epic;
      case 4:
        return EquipmentRarity.legendary;
      case 5:
        return EquipmentRarity.mythic;
      default:
        return EquipmentRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, EquipmentRarity obj) {
    switch (obj) {
      case EquipmentRarity.common:
        writer.writeByte(0);
        break;
      case EquipmentRarity.uncommon:
        writer.writeByte(1);
        break;
      case EquipmentRarity.rare:
        writer.writeByte(2);
        break;
      case EquipmentRarity.epic:
        writer.writeByte(3);
        break;
      case EquipmentRarity.legendary:
        writer.writeByte(4);
        break;
      case EquipmentRarity.mythic:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EquipmentSlotAdapter extends TypeAdapter<EquipmentSlot> {
  @override
  final int typeId = 15;

  @override
  EquipmentSlot read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EquipmentSlot.weapon;
      case 1:
        return EquipmentSlot.armor;
      case 2:
        return EquipmentSlot.accessory;
      default:
        return EquipmentSlot.weapon;
    }
  }

  @override
  void write(BinaryWriter writer, EquipmentSlot obj) {
    switch (obj) {
      case EquipmentSlot.weapon:
        writer.writeByte(0);
        break;
      case EquipmentSlot.armor:
        writer.writeByte(1);
        break;
      case EquipmentSlot.accessory:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentSlotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeaponTypeAdapter extends TypeAdapter<WeaponType> {
  @override
  final int typeId = 16;

  @override
  WeaponType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WeaponType.oneHandedWeapon;
      case 1:
        return WeaponType.oneHandedShield;
      case 2:
        return WeaponType.twoHandedWeapon;
      default:
        return WeaponType.oneHandedWeapon;
    }
  }

  @override
  void write(BinaryWriter writer, WeaponType obj) {
    switch (obj) {
      case WeaponType.oneHandedWeapon:
        writer.writeByte(0);
        break;
      case WeaponType.oneHandedShield:
        writer.writeByte(1);
        break;
      case WeaponType.twoHandedWeapon:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeaponTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ArmorTypeAdapter extends TypeAdapter<ArmorType> {
  @override
  final int typeId = 17;

  @override
  ArmorType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ArmorType.head;
      case 1:
        return ArmorType.body;
      default:
        return ArmorType.head;
    }
  }

  @override
  void write(BinaryWriter writer, ArmorType obj) {
    switch (obj) {
      case ArmorType.head:
        writer.writeByte(0);
        break;
      case ArmorType.body:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArmorTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccessoryTypeAdapter extends TypeAdapter<AccessoryType> {
  @override
  final int typeId = 18;

  @override
  AccessoryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AccessoryType.amulet;
      case 1:
        return AccessoryType.charm;
      case 2:
        return AccessoryType.glove;
      case 3:
        return AccessoryType.shoes;
      case 5:
        return AccessoryType.pendant;
      default:
        return AccessoryType.amulet;
    }
  }

  @override
  void write(BinaryWriter writer, AccessoryType obj) {
    switch (obj) {
      case AccessoryType.amulet:
        writer.writeByte(0);
        break;
      case AccessoryType.charm:
        writer.writeByte(1);
        break;
      case AccessoryType.glove:
        writer.writeByte(2);
        break;
      case AccessoryType.shoes:
        writer.writeByte(3);
        break;
      case AccessoryType.pendant:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessoryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
