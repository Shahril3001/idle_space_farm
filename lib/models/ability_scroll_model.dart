import 'package:hive/hive.dart';
import '../data/ability_data.dart';
import '../models/ability_model.dart';
import '../models/girl_farmer_model.dart';

part 'ability_scroll_model.g.dart';

@HiveType(typeId: 19)
class AbilityScroll {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String
      iconAsset; // Path to image asset like 'assets/scrolls/fireball.png'

  @HiveField(4)
  final String abilityId; // References abilitiesList

  @HiveField(5)
  final ScrollRarity rarity;

  @HiveField(6)
  final List<String> allowedTypes; // Character classes that can learn

  @HiveField(7)
  final List<String> allowedRaces; // Races that can learn

  @HiveField(8)
  final int minLevel; // Minimum character level required

  @HiveField(9)
  final Map<String, int> requiredStats; // Minimum stats required

  @HiveField(10)
  final bool isConsumable; // Whether scroll disappears after use

  AbilityScroll({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.abilityId,
    this.rarity = ScrollRarity.common,
    this.allowedTypes = const [], // Empty = no class restriction
    this.allowedRaces = const [], // Empty = no race restriction
    this.minLevel = 1,
    this.requiredStats = const {}, // Ex: {'attackPoints': 10}
    this.isConsumable = true,
  });

  AbilitiesModel? get ability {
    try {
      return abilitiesList.firstWhere((a) => a.abilitiesID == abilityId);
    } catch (e) {
      return null;
    }
  }

  bool canBeLearnedBy(GirlFarmer girl) {
    // Check type/class restriction
    if (allowedTypes.isNotEmpty && !allowedTypes.contains(girl.type)) {
      return false;
    }

    // Check race restriction
    if (allowedRaces.isNotEmpty && !allowedRaces.contains(girl.race)) {
      return false;
    }

    // Check level requirement
    if (girl.level < minLevel) {
      return false;
    }

    // Check stat requirements
    for (final stat in requiredStats.entries) {
      final girlStatValue = switch (stat.key) {
        'attackPoints' => girl.attackPoints,
        'defensePoints' => girl.defensePoints,
        'agilityPoints' => girl.agilityPoints,
        'hp' => girl.maxHp,
        'mp' => girl.maxMp,
        'sp' => girl.maxSp,
        'criticalPoint' => girl.criticalPoint,
        _ => 0,
      };

      if (girlStatValue < stat.value) {
        return false;
      }
    }

    return true;
  }

  bool use(GirlFarmer girl) {
    if (!canBeLearnedBy(girl)) return false;

    final abilityToLearn = ability;
    if (abilityToLearn == null) return false;

    // Check if already knows this ability
    if (girl.abilities.any((a) => a.abilitiesID == abilityId)) {
      return false;
    }

    // Learn the ability
    girl.addAbility(abilityToLearn);
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconAsset': iconAsset,
      'abilityId': abilityId,
      'rarity': rarity.index,
      'allowedTypes': allowedTypes,
      'allowedRaces': allowedRaces,
      'minLevel': minLevel,
      'requiredStats': requiredStats,
      'isConsumable': isConsumable,
    };
  }

  factory AbilityScroll.fromMap(Map<String, dynamic> map) {
    return AbilityScroll(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      iconAsset: map['iconAsset'],
      abilityId: map['abilityId'],
      rarity: ScrollRarity.values[map['rarity']],
      allowedTypes: List<String>.from(map['allowedTypes']),
      allowedRaces: List<String>.from(map['allowedRaces']),
      minLevel: map['minLevel'],
      requiredStats: Map<String, int>.from(map['requiredStats']),
      isConsumable: map['isConsumable'],
    );
  }
}

@HiveType(typeId: 20)
enum ScrollRarity {
  @HiveField(0)
  common,
  @HiveField(1)
  uncommon,
  @HiveField(2)
  rare,
  @HiveField(3)
  epic,
}
