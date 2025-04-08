// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopModelAdapter extends TypeAdapter<ShopModel> {
  @override
  final int typeId = 23;

  @override
  ShopModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopModel(
      categories: (fields[0] as List).cast<ShopCategory>(),
      currencyValues: (fields[1] as Map?)?.cast<String, double>(),
      purchasedItemIds: (fields[3] as List).cast<String>().toSet(),
    ).._lastRefreshTime = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, ShopModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.categories)
      ..writeByte(1)
      ..write(obj.currencyValues)
      ..writeByte(2)
      ..write(obj._lastRefreshTime)
      ..writeByte(3)
      ..write(obj.purchasedItemIds.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShopCategoryAdapter extends TypeAdapter<ShopCategory> {
  @override
  final int typeId = 24;

  @override
  ShopCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopCategory(
      id: fields[0] as String,
      name: fields[1] as String,
      iconPath: fields[2] as String,
      items: (fields[3] as List).cast<ShopItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, ShopCategory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconPath)
      ..writeByte(3)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShopItemAdapter extends TypeAdapter<ShopItem> {
  @override
  final int typeId = 25;

  @override
  ShopItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopItem(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as ShopItemType,
      itemId: fields[3] as String,
      prices: (fields[4] as Map).cast<String, int>(),
      stock: fields[5] as int?,
      purchaseLimit: fields[6] as int?,
      description: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShopItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.itemId)
      ..writeByte(4)
      ..write(obj.prices)
      ..writeByte(5)
      ..write(obj.stock)
      ..writeByte(6)
      ..write(obj.purchaseLimit)
      ..writeByte(7)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShopItemTypeAdapter extends TypeAdapter<ShopItemType> {
  @override
  final int typeId = 26;

  @override
  ShopItemType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ShopItemType.girl;
      case 1:
        return ShopItemType.equipment;
      case 2:
        return ShopItemType.potion;
      case 3:
        return ShopItemType.abilityScroll;
      default:
        return ShopItemType.girl;
    }
  }

  @override
  void write(BinaryWriter writer, ShopItemType obj) {
    switch (obj) {
      case ShopItemType.girl:
        writer.writeByte(0);
        break;
      case ShopItemType.equipment:
        writer.writeByte(1);
        break;
      case ShopItemType.potion:
        writer.writeByte(2);
        break;
      case ShopItemType.abilityScroll:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopItemTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
