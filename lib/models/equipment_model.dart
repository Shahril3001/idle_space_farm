import 'package:hive/hive.dart';

part 'equipment_model.g.dart';

@HiveType(typeId: 14)
enum EquipmentRarity {
  @HiveField(0)
  common, // 34%
  @HiveField(1)
  uncommon, // 30%
  @HiveField(2)
  rare, // 20%
  @HiveField(3)
  epic, // 10%
  @HiveField(4)
  legendary, // 5%
  @HiveField(5)
  mythic // 1%
}

@HiveType(typeId: 15)
enum EquipmentSlot {
  @HiveField(0)
  weapon,
  @HiveField(1)
  armor,
  @HiveField(2)
  accessory,
}

@HiveType(typeId: 16) // New typeId for weapon type
enum WeaponType {
  @HiveField(0)
  oneHandedWeapon, // Sword, dagger, etc.
  @HiveField(1)
  oneHandedShield, // Shield
  @HiveField(2)
  twoHandedWeapon, // Greatsword, longbow, spear
}

@HiveType(typeId: 17) // New typeId for armor type
enum ArmorType {
  @HiveField(0)
  head,
  @HiveField(1)
  body,
}

@HiveType(typeId: 18) // New typeId for accessory type
enum AccessoryType {
  @HiveField(0)
  amulet,
  @HiveField(1)
  charm,
  @HiveField(2)
  glove,
  @HiveField(3)
  shoes,
  @HiveField(5)
  pendant,
}

@HiveType(typeId: 13)
class Equipment {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final EquipmentSlot slot;

  @HiveField(3)
  final int attackBonus;

  @HiveField(4)
  final int defenseBonus;

  @HiveField(5)
  final int hpBonus;

  @HiveField(6)
  final int agilityBonus;

  @HiveField(7)
  int enhancementLevel;

  @HiveField(8)
  final EquipmentRarity rarity;

  @HiveField(9)
  final List<String> allowedTypes;

  @HiveField(10)
  final List<String> allowedRaces;

  @HiveField(11)
  final bool isTradable;

  @HiveField(12)
  final int mpBonus;

  @HiveField(13)
  final int spBonus;

  @HiveField(14)
  final int criticalPoint;

  @HiveField(15)
  String? assignedTo; // ID of the girl this equipment is assigned to
  // New fields for equipment subtypes
  @HiveField(16)
  final WeaponType? weaponType; // Only for weapons

  @HiveField(17)
  final ArmorType? armorType; // Only for armor

  @HiveField(18)
  final AccessoryType? accessoryType; // Only for accessories

  Equipment({
    required this.id,
    required this.name,
    required this.slot,
    required this.rarity,
    this.weaponType,
    this.armorType,
    this.accessoryType,
    this.attackBonus = 0,
    this.defenseBonus = 0,
    this.hpBonus = 0,
    this.agilityBonus = 0,
    this.enhancementLevel = 0,
    this.allowedTypes = const [],
    this.allowedRaces = const [],
    this.isTradable = true,
    this.mpBonus = 0,
    this.spBonus = 0,
    this.criticalPoint = 0,
    this.assignedTo,
  }) {
    // Validate that the correct type is set based on slot
    assert(
      (slot == EquipmentSlot.weapon && weaponType != null) ||
          (slot != EquipmentSlot.weapon && weaponType == null),
      'Weapon type must be set only for weapons',
    );
    assert(
      (slot == EquipmentSlot.armor && armorType != null) ||
          (slot != EquipmentSlot.armor && armorType == null),
      'Armor type must be set only for armor',
    );
    assert(
      (slot == EquipmentSlot.accessory && accessoryType != null) ||
          (slot != EquipmentSlot.accessory && accessoryType == null),
      'Accessory type must be set only for accessories',
    );
  }

  // Get scaled stats based on enhancement
  int get scaledAttack => (attackBonus * (1 + enhancementLevel * 0.1)).round();
  int get scaledDefense =>
      (defenseBonus * (1 + enhancementLevel * 0.1)).round();
  int get scaledHp => (hpBonus * (1 + enhancementLevel * 0.1)).round();
  int get scaledAgility =>
      (agilityBonus * (1 + enhancementLevel * 0.1)).round();
  int get scaledMp => (mpBonus * (1 + enhancementLevel * 0.1)).round();
  int get scaledSp => (spBonus * (1 + enhancementLevel * 0.1)).round();
  int get scaledCriticalPoint =>
      (criticalPoint * (1 + enhancementLevel * 0.1)).round();

  // Simple enhancement system
  bool enhance() {
    if (enhancementLevel >= 5) return false; // Max +5 enhancement
    enhancementLevel++;
    return true;
  }

  // For UI display
  String get displayName {
    return enhancementLevel > 0 ? '$name +$enhancementLevel' : name;
  }

  // New method to check if equipment can be equipped with current setup
  static bool canEquip(List<Equipment> currentlyEquipped, Equipment newItem) {
    final weaponCount =
        currentlyEquipped.where((e) => e.slot == EquipmentSlot.weapon).length;
    final armorCount =
        currentlyEquipped.where((e) => e.slot == EquipmentSlot.armor).length;
    final accessoryCount = currentlyEquipped
        .where((e) => e.slot == EquipmentSlot.accessory)
        .length;

    // Check if we're replacing an existing item
    final isReplacing = currentlyEquipped.any((e) => e.slot == newItem.slot);

    if (!isReplacing) {
      // Check slot limits
      switch (newItem.slot) {
        case EquipmentSlot.weapon:
          if (weaponCount >= 2) return false;
          // Check weapon type combinations
          final weapons = currentlyEquipped
              .where((e) => e.slot == EquipmentSlot.weapon)
              .toList();
          if (weapons.length == 1) {
            final existingWeapon = weapons.first;
            // Can't have two two-handed weapons
            if (existingWeapon.weaponType == WeaponType.twoHandedWeapon ||
                newItem.weaponType == WeaponType.twoHandedWeapon) {
              return false;
            }
            // Can't have two shields
            if (existingWeapon.weaponType == WeaponType.oneHandedShield &&
                newItem.weaponType == WeaponType.oneHandedShield) {
              return false;
            }
          }
          break;
        case EquipmentSlot.armor:
          if (armorCount >= 2) return false;
          // Check armor type combinations
          final armors = currentlyEquipped
              .where((e) => e.slot == EquipmentSlot.armor)
              .toList();
          if (armors.length == 1) {
            // Can't have two of the same armor type
            if (armors.first.armorType == newItem.armorType) {
              return false;
            }
          }
          break;
        case EquipmentSlot.accessory:
          if (accessoryCount >= 3) return false;
          // Check accessory type combinations
          final accessories = currentlyEquipped
              .where((e) => e.slot == EquipmentSlot.accessory)
              .toList();
          // Can't have more than one of the same accessory type
          if (accessories
              .any((a) => a.accessoryType == newItem.accessoryType)) {
            return false;
          }
          break;
      }
    }

    return true;
  }

  factory Equipment.fromMap(Map<String, dynamic> map) {
    return Equipment(
      id: map['id'] as String,
      name: map['name'] as String,
      slot: EquipmentSlot.values[map['slot'] as int],
      rarity: EquipmentRarity.values[map['rarity'] as int],
      weaponType: map['weaponType'] != null
          ? WeaponType.values[map['weaponType'] as int]
          : null,
      armorType: map['armorType'] != null
          ? ArmorType.values[map['armorType'] as int]
          : null,
      accessoryType: map['accessoryType'] != null
          ? AccessoryType.values[map['accessoryType'] as int]
          : null,
      attackBonus: map['attackBonus'] as int,
      defenseBonus: map['defenseBonus'] as int,
      hpBonus: map['hpBonus'] as int,
      agilityBonus: map['agilityBonus'] as int,
      enhancementLevel: map['enhancementLevel'] as int,
      allowedTypes: List<String>.from(map['allowedTypes'] ?? []),
      allowedRaces: List<String>.from(map['allowedRaces'] ?? []),
      isTradable: map['isTradable'] as bool? ?? true,
      mpBonus: map['mpBonus'] as int? ?? 0,
      spBonus: map['spBonus'] as int? ?? 0,
      criticalPoint: map['criticalPoint'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slot': slot.index,
      'rarity': rarity.index,
      'weaponType': weaponType?.index,
      'armorType': armorType?.index,
      'accessoryType': accessoryType?.index,
      'attackBonus': attackBonus,
      'defenseBonus': defenseBonus,
      'hpBonus': hpBonus,
      'agilityBonus': agilityBonus,
      'enhancementLevel': enhancementLevel,
      'allowedTypes': allowedTypes,
      'allowedRaces': allowedRaces,
      'isTradable': isTradable,
      'mpBonus': mpBonus,
      'spBonus': spBonus,
      'criticalPoint': criticalPoint,
    };
  }
}
