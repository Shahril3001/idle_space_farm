import 'dart:math';
import 'package:hive/hive.dart';
import 'ability_model.dart';

part 'enemy_model.g.dart';

@HiveType(typeId: 5)
class Enemy {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  int level;

  @HiveField(3)
  int attackPoints;

  @HiveField(4)
  int defensePoints;

  @HiveField(5)
  int agilityPoints;

  @HiveField(6)
  int hp;

  @HiveField(7)
  int mp;

  @HiveField(8)
  int sp;

  @HiveField(9)
  List<AbilitiesModel> abilities;

  @HiveField(10)
  final String rarity;

  @HiveField(11)
  final String type;

  @HiveField(12)
  final String region;

  @HiveField(13)
  final String description;

  @HiveField(14)
  int maxHp;

  @HiveField(15)
  int maxMp;

  @HiveField(16)
  int maxSp;

  @HiveField(17)
  int criticalPoint;

  @HiveField(18)
  Map<String, int> currentCooldowns;

  Enemy({
    required this.id,
    required this.name,
    required this.level,
    required this.attackPoints,
    required this.defensePoints,
    required this.agilityPoints,
    required this.hp,
    required this.mp,
    required this.sp,
    required this.abilities,
    required this.rarity,
    required this.type,
    required this.region,
    required this.description,
    this.maxHp = 100,
    this.maxMp = 50,
    this.maxSp = 30,
    this.criticalPoint = 5,
    this.currentCooldowns = const {},
  });

  factory Enemy.freshCopy(Enemy other) {
    return Enemy(
      id: '${other.id}-${DateTime.now().millisecondsSinceEpoch}',
      name: other.name,
      level: other.level,
      attackPoints: other.attackPoints,
      defensePoints: other.defensePoints,
      agilityPoints: other.agilityPoints,
      hp: other.maxHp,
      mp: other.maxMp,
      sp: other.maxSp,
      abilities: other.abilities.map((a) => a.freshCopy()).toList(),
      rarity: other.rarity,
      type: other.type,
      region: other.region,
      description: other.description,
      maxHp: other.maxHp,
      maxMp: other.maxMp,
      maxSp: other.maxSp,
      criticalPoint: other.criticalPoint,
      currentCooldowns: {},
    );
  }

  bool useAbility(AbilitiesModel ability, dynamic target) {
    if (!abilities.contains(ability)) {
      print("${name} does not know ${ability.name}.");
      return false;
    }

    if (currentCooldowns[ability.abilitiesID] != null &&
        currentCooldowns[ability.abilitiesID]! > 0) {
      print(
          "${ability.name} is on cooldown for ${currentCooldowns[ability.abilitiesID]} more turns.");
      return false;
    }

    final success = ability.useAbility(this, target);
    if (success) {
      currentCooldowns[ability.abilitiesID] = ability.cooldown;
    }
    return success;
  }

  void updateCooldowns() {
    currentCooldowns.forEach((abilitiesID, cooldown) {
      if (cooldown > 0) {
        currentCooldowns[abilitiesID] = cooldown - 1;
      }
    });
  }

  void restoreStats() {
    hp = maxHp;
    mp = maxMp;
    sp = maxSp;
    currentCooldowns.clear();
  }
}
