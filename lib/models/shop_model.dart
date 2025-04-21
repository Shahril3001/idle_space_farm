import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math';

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
  final Set<String> purchasedItemIds; // Only tracks girls and equipment

  @HiveField(4)
  int _refreshCountToday = 0;

  @HiveField(5)
  DateTime _lastDailyReset;

  DateTime get lastRefreshTime => _lastRefreshTime;
  int get refreshCountToday => _refreshCountToday;
  DateTime get lastDailyReset => _lastDailyReset;

  bool needsDailyReset(DateTime now) {
    // Convert to Singapore timezone
    final singapore = tz.getLocation('Asia/Singapore');
    final nowSgt = tz.TZDateTime.from(now, singapore);
    final lastResetSgt = tz.TZDateTime.from(_lastDailyReset, singapore);

    // Reset if:
    // 1. It's a different day, OR
    // 2. It's the same day but last reset was before 8:00 AM and now is after 8:00 AM
    return !isSameDay(nowSgt, lastResetSgt) ||
        (lastResetSgt.hour < 8 && nowSgt.hour >= 8);
  }

  set lastDailyReset(DateTime value) => _lastDailyReset = value;
  set refreshCountToday(int value) => _refreshCountToday = value;
  set lastRefreshTime(DateTime value) => _lastRefreshTime = value;

  ShopModel({
    required this.categories,
    Map<String, double>? currencyValues,
    DateTime? lastRefreshTime,
    Set<String>? purchasedItemIds,
    int? refreshCountToday,
    DateTime? lastDailyReset,
  })  : currencyValues = currencyValues ??
            {
              'Energy': 1.0,
              'Minerals': 0.8,
              'Credits': 1.2,
            },
        _lastRefreshTime = lastRefreshTime ?? DateTime.now(),
        purchasedItemIds = purchasedItemIds ?? {},
        _refreshCountToday = refreshCountToday ?? 0,
        _lastDailyReset = lastDailyReset ?? DateTime.now();

  List<ShopItem> get allItems => categories.expand((c) => c.items).toList();

  bool get canRefresh {
    final now = DateTime.now();
    final singapore = tz.getLocation('Asia/Singapore');
    final nowSgt = tz.TZDateTime.from(now, singapore);

    if (needsDailyReset(nowSgt)) {
      _refreshCountToday = 0;
      _lastDailyReset = nowSgt;
      return true;
    }
    return _refreshCountToday < 3;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void refreshShop(List<ShopCategory> newCategories) {
    if (!canRefresh) return;

    // Only keep tracking of purchased girls and equipment
    final purchasedIds = purchasedItemIds.where((id) {
      final item = allItems.firstWhereOrNull((item) => item.id == id);
      return item != null &&
          item.type != ShopItemType.potion &&
          item.type != ShopItemType.abilityScroll;
    }).toSet();

    // Clear all purchased items
    purchasedItemIds.clear();

    // Re-add only the girls and equipment that were purchased
    purchasedItemIds.addAll(purchasedIds);

    _refreshCountToday++;
    _lastRefreshTime = DateTime.now();
    categories
      ..clear()
      ..addAll(newCategories);
  }

  bool canPurchase(ShopItem item) {
    // Potions and abilities can always be purchased
    if (item.type == ShopItemType.potion ||
        item.type == ShopItemType.abilityScroll) {
      return true;
    }
    // For other items, check if not already purchased
    return !purchasedItemIds.contains(item.id);
  }

  void recordPurchase(ShopItem item) {
    // Only record purchases for girls and equipment
    if (item.type != ShopItemType.potion &&
        item.type != ShopItemType.abilityScroll) {
      purchasedItemIds.add(item.id);
    }
  }

  ShopModel copyWith({
    List<ShopCategory>? categories,
    DateTime? lastRefreshTime,
    Set<String>? purchasedItemIds,
    int? refreshCountToday,
    DateTime? lastDailyReset,
  }) {
    return ShopModel(
      categories: categories ?? this.categories,
      lastRefreshTime: lastRefreshTime ?? this._lastRefreshTime,
      purchasedItemIds: purchasedItemIds ?? this.purchasedItemIds,
      refreshCountToday: refreshCountToday ?? this._refreshCountToday,
      lastDailyReset: lastDailyReset ?? this._lastDailyReset,
    );
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
  final String itemId;

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

final Random random = Random();

List<ShopCategory> createDefaultShopCategories() {
  final girlItems = (List.of(girlsData)..shuffle(random))
      .take(9)
      .map((girl) => createShopItemFromGirl(girl))
      .toList();

  final equipmentItems = (List.of(equipmentList)..shuffle(random))
      .take(9)
      .map((equip) => createShopItemFromEquipment(equip))
      .toList();

  final potionItems = (List.of(PotionDatabase.allPotions)..shuffle(random))
      .take(9)
      .map((potion) => createShopItemFromPotion(potion))
      .toList();

  final abilityItems = (List.of(abilitiesList)..shuffle(random))
      .take(9)
      .map((ability) => createShopItemFromAbility(ability))
      .toList();

  return [
    ShopCategory(
      id: 'girls',
      name: 'Girl',
      iconPath: 'assets/images/icons/shop-girl.png',
      items: girlItems,
    ),
    ShopCategory(
      id: 'equipment',
      name: 'Equipment',
      iconPath: 'assets/images/icons/shop-equipment.png',
      items: equipmentItems,
    ),
    ShopCategory(
      id: 'potions',
      name: 'Potion',
      iconPath: 'assets/images/icons/shop-potion.png',
      items: potionItems,
    ),
    ShopCategory(
      id: 'abilities',
      name: 'Ability',
      iconPath: 'assets/images/icons/shop-abilities.png',
      items: abilityItems,
    ),
  ];
}
