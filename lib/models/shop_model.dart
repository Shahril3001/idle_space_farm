import 'package:hive/hive.dart';
import 'package:collection/collection.dart';

import '../data/ability_data.dart';
import '../data/equipment_data.dart';
import '../data/girl_data.dart';
import '../data/potion_data.dart';
import 'ability_model.dart';
import 'equipment_model.dart';
import 'girl_farmer_model.dart';
import 'potion_model.dart';

part 'shop_model.g.dart';

@HiveType(typeId: 23)
class ShopModel {
  @HiveField(0)
  final List<ShopCategory> categories;

  @HiveField(1)
  final Map<String, double> currencyValues;

  @HiveField(2)
  DateTime _lastRefreshTime;

  @HiveField(3)
  final Set<String> purchasedItemIds;

  DateTime get lastRefreshTime => _lastRefreshTime;

  ShopModel({
    required this.categories,
    Map<String, double>? currencyValues,
    DateTime? lastRefreshTime,
    Set<String>? purchasedItemIds,
  })  : currencyValues = currencyValues ??
            {
              'Energy': 1.0,
              'Minerals': 0.8,
              'Credits': 1.2,
            },
        _lastRefreshTime = lastRefreshTime ?? DateTime.now(),
        purchasedItemIds = purchasedItemIds ?? {};

  List<ShopItem> get allItems => categories.expand((c) => c.items).toList();

  ShopModel copyWith({
    List<ShopCategory>? categories,
    DateTime? lastRefreshTime,
    Set<String>? purchasedItemIds,
  }) {
    return ShopModel(
      categories: categories ?? this.categories,
      lastRefreshTime: lastRefreshTime ?? this.lastRefreshTime,
      purchasedItemIds: purchasedItemIds ?? this.purchasedItemIds,
    );
  }

  void recordPurchase(String itemId) {
    purchasedItemIds.add(itemId);
  }

  double convertCurrency(double amount, String from, String to) {
    final fromValue = currencyValues[from] ?? 1.0;
    final toValue = currencyValues[to] ?? 1.0;
    return amount * (toValue / fromValue);
  }
}

@HiveType(typeId: 24)
class ShopCategory {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String iconPath;

  @HiveField(3)
  final List<ShopItem> items;

  ShopCategory({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.items,
  });

  ShopCategory copyWith({
    String? id,
    String? name,
    String? iconPath,
    List<ShopItem>? items,
  }) {
    return ShopCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      items: items ?? this.items,
    );
  }
}

@HiveType(typeId: 25)
class ShopItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final ShopItemType type;

  @HiveField(3)
  final String itemId; // ID of the actual item (girl, equipment, etc.)

  @HiveField(4)
  final Map<String, int> prices;

  @HiveField(5)
  final int? stock;

  @HiveField(6)
  final int? purchaseLimit;

  @HiveField(7)
  final String description;

  ShopItem({
    required this.id,
    required this.name,
    required this.type,
    required this.itemId,
    required this.prices,
    this.stock,
    this.purchaseLimit,
    this.description = '',
  });

  ShopItem copyWith({
    String? id,
    String? name,
    ShopItemType? type,
    String? itemId,
    Map<String, int>? prices,
    int? stock,
    int? purchaseLimit,
    String? description,
  }) {
    return ShopItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      itemId: itemId ?? this.itemId,
      prices: prices ?? this.prices,
      stock: stock ?? this.stock,
      purchaseLimit: purchaseLimit ?? this.purchaseLimit,
      description: description ?? this.description,
    );
  }

  bool canAfford(Map<String, double> playerResources) {
    return prices.entries.every((price) {
      final playerAmount = playerResources[price.key] ?? 0;
      return playerAmount >= price.value;
    });
  }

  bool get hasStock => stock == null || stock! > 0;
}

@HiveType(typeId: 26)
enum ShopItemType {
  @HiveField(0)
  girl,

  @HiveField(1)
  equipment,

  @HiveField(2)
  potion,

  @HiveField(3)
  abilityScroll,
}

// Helper functions to create shop items from data models
ShopItem createShopItemFromEquipment(Equipment eq) => ShopItem(
      itemId: eq.id,
      id: 'equip_${eq.id}',
      name: eq.name,
      description: 'A piece of equipment: ${eq.name}',
      prices: {'Credits': _calculateEquipmentPrice(eq)},
      type: ShopItemType.equipment,
    );

ShopItem createShopItemFromGirl(GirlFarmer girl) => ShopItem(
      itemId: girl.id,
      id: 'girl_${girl.id}',
      name: girl.name,
      description: girl.description,
      prices: {'Credits': _calculateGirlPrice(girl)},
      type: ShopItemType.girl,
    );

ShopItem createShopItemFromPotion(Potion potion) => ShopItem(
      itemId: potion.id,
      id: 'potion_${potion.id}',
      name: potion.name,
      description: potion.description,
      prices: {'Credits': potion.rarity == PotionRarity.common ? 100 : 250},
      stock: 5,
      type: ShopItemType.potion,
    );

ShopItem createShopItemFromAbility(AbilitiesModel ability) => ShopItem(
      itemId: ability.abilitiesID,
      id: 'ability_${ability.abilitiesID}',
      name: ability.name,
      description: ability.description,
      prices: {'Credits': 500},
      type: ShopItemType.abilityScroll,
    );

// Price calculation methods
int _calculateGirlPrice(GirlFarmer girl) {
  return switch (girl.rarity) {
    'Common' => 1000,
    'Rare' => 2500,
    'Unique' => 5000,
    _ => 1000,
  };
}

int _calculateEquipmentPrice(Equipment equip) {
  return switch (equip.rarity) {
    EquipmentRarity.common => 500,
    EquipmentRarity.uncommon => 1000,
    EquipmentRarity.rare => 2000,
    EquipmentRarity.epic => 4000,
    EquipmentRarity.legendary => 8000,
    EquipmentRarity.mythic => 15000,
  };
}

// Default shop creation
List<ShopCategory> createDefaultShopCategories() {
  return [
    ShopCategory(
      id: 'girls',
      name: 'Girls',
      iconPath: 'assets/icons/shop_girls.png',
      items: girlsData
          .take(5)
          .map((girl) => createShopItemFromGirl(girl))
          .toList(),
    ),
    ShopCategory(
      id: 'equipment',
      name: 'Equipment',
      iconPath: 'assets/icons/shop_equipment.png',
      items: equipmentList
          .take(5)
          .map((equip) => createShopItemFromEquipment(equip))
          .toList(),
    ),
    ShopCategory(
      id: 'potions',
      name: 'Potions',
      iconPath: 'assets/icons/shop_potions.png',
      items: PotionDatabase.allPotions
          .take(3)
          .map((potion) => createShopItemFromPotion(potion))
          .toList(),
    ),
    ShopCategory(
      id: 'abilities',
      name: 'Ability Scrolls',
      iconPath: 'assets/icons/shop_scrolls.png',
      items: abilitiesList
          .take(3)
          .map((ability) => createShopItemFromAbility(ability))
          .toList(),
    ),
  ];
}
