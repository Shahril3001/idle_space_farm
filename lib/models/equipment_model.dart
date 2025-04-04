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

  @HiveField(15) // New field
  String? assignedTo; // ID of the girl this equipment is assigned to

  Equipment({
    required this.id,
    required this.name,
    required this.slot,
    required this.rarity,
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
  });

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

  factory Equipment.fromMap(Map<String, dynamic> map) {
    return Equipment(
      id: map['id'] as String,
      name: map['name'] as String,
      slot: EquipmentSlot.values[map['slot'] as int],
      rarity: EquipmentRarity.values[map['rarity'] as int],
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
