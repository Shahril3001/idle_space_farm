import 'dart:math';
import 'package:hive/hive.dart';
import 'ability_model.dart'; // Import the AbilitiesModel

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
  List<AbilitiesModel> abilities; // List of AbilitiesModel

  @HiveField(10)
  final String rarity;

  @HiveField(11)
  final String type;

  @HiveField(12)
  final String region;

  @HiveField(13)
  final String description;

  @HiveField(14)
  int maxHp; // Maximum HP

  @HiveField(15)
  int maxMp; // Maximum MP

  @HiveField(16)
  int maxSp; // Maximum SP

  @HiveField(17)
  int criticalPoint; // Critical hit chance or damage multiplier

  @HiveField(18)
  Map<String, int> currentCooldowns; // Track cooldowns for abilities

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
    required this.abilities, // Initialize with a list of AbilitiesModel
    required this.rarity,
    required this.type,
    required this.region,
    required this.description,
    this.maxHp = 100,
    this.maxMp = 50,
    this.maxSp = 30,
    this.criticalPoint = 5,
    this.currentCooldowns = const {}, // Initialize with an empty map
  });

  // Use an ability on a target
  bool useAbility(AbilitiesModel ability, dynamic target) {
    if (!abilities.contains(ability)) {
      print("${name} does not know ${ability.name}.");
      return false;
    }

    // Check cooldown
    if (currentCooldowns[ability.abilitiesID] != null &&
        currentCooldowns[ability.abilitiesID]! > 0) {
      print(
          "${ability.name} is on cooldown for ${currentCooldowns[ability.abilitiesID]} more turns.");
      return false;
    }

    // Use the ability
    final success = ability.useAbility(this, target);
    if (success) {
      // Set cooldown
      currentCooldowns[ability.abilitiesID] = ability.cooldown;
    }
    return success;
  }

  // Update cooldowns at the end of each turn
  void updateCooldowns() {
    currentCooldowns.forEach((abilitiesID, cooldown) {
      if (cooldown > 0) {
        currentCooldowns[abilitiesID] = cooldown - 1;
      }
    });
  }

  // Restore stats (optional: reset cooldowns)
  void restoreStats() {
    hp = maxHp;
    mp = maxMp;
    sp = maxSp;
    currentCooldowns.clear(); // Reset all cooldowns
  }
}
