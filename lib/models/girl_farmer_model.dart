import 'dart:math';
import 'package:hive/hive.dart';
import 'ability_model.dart';

part 'girl_farmer_model.g.dart';

@HiveType(typeId: 2)
class GirlFarmer {
  @HiveField(0)
  String id; // Unique identifier

  @HiveField(1)
  String name;

  @HiveField(2)
  int level;

  @HiveField(3)
  double miningEfficiency;

  @HiveField(4)
  String? assignedFarm;

  @HiveField(5)
  String rarity; // Common, Rare, Unique

  @HiveField(6)
  int stars; // 1-6

  @HiveField(7)
  String image; // Path to the girl's full-body image

  @HiveField(8)
  String imageFace; // Path to the girl's face image

  @HiveField(9)
  int attackPoints;

  @HiveField(10)
  int defensePoints;

  @HiveField(11)
  int agilityPoints;

  @HiveField(12)
  int hp;

  @HiveField(13)
  int mp;

  @HiveField(14)
  int sp;

  @HiveField(15)
  List<AbilitiesModel> abilities; // List of AbilitiesModel

  @HiveField(16)
  String race; // Human, Elf, Demon, etc.

  @HiveField(17)
  String type; // Warrior, Mage, Assassin, etc.

  @HiveField(18)
  String region; // East, West, North, etc.

  @HiveField(19)
  String description; // Detailed character description

  @HiveField(20)
  int maxHp; // Maximum HP

  @HiveField(21)
  int maxMp; // Maximum MP

  @HiveField(22)
  int maxSp; // Maximum SP

  @HiveField(23)
  int criticalPoint; // Critical hit chance or damage multiplier

  @HiveField(24)
  Map<String, int> currentCooldowns; // Track cooldowns for abilities

  GirlFarmer({
    required this.id,
    this.name = "",
    this.level = 1,
    this.miningEfficiency = 1.0,
    this.assignedFarm,
    required this.rarity,
    required this.stars,
    required this.image,
    required this.imageFace,
    this.attackPoints = 10,
    this.defensePoints = 5,
    this.agilityPoints = 7,
    this.hp = 100,
    this.mp = 50,
    this.sp = 30,
    this.abilities =
        const [], // Initialize with an empty list of AbilitiesModel
    required this.race,
    required this.type,
    required this.region,
    this.description = "A skilled farmer with a strong connection to the land.",
    this.maxHp = 100,
    this.maxMp = 50,
    this.maxSp = 30,
    this.criticalPoint = 5,
    this.currentCooldowns = const {}, // Initialize with an empty map
  });

  GirlFarmer copyWithFreshStats() {
    return GirlFarmer(
      id: id,
      name: name,
      level: level,
      miningEfficiency: miningEfficiency,
      assignedFarm: assignedFarm,
      rarity: rarity,
      stars: stars,
      image: image,
      imageFace: imageFace,
      attackPoints: attackPoints,
      defensePoints: defensePoints,
      agilityPoints: agilityPoints,
      hp: maxHp, // Reset to full HP
      maxHp: maxHp,
      mp: maxMp, // Reset to full MP
      maxMp: maxMp,
      sp: maxSp, // Reset to full SP
      maxSp: maxSp,
      abilities: abilities.map((a) => a.freshCopy()).toList(),
      race: race,
      type: type,
      region: region,
      description: description,
      criticalPoint: criticalPoint,
      currentCooldowns: {}, // Fresh modifiable empty map
      // Alternative if you need to preserve some cooldowns:
      // currentCooldowns: Map.from(currentCooldowns)..removeWhere((_, cd) => cd <= 0),
    );
  }

  // Add an ability
  void addAbility(AbilitiesModel ability) {
    abilities.add(ability);
  }

  // Remove an ability
  void removeAbility(String abilitiesID) {
    abilities.removeWhere((ability) => ability.abilitiesID == abilitiesID);
  }

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

  // Upgrade the girl farmer (optional: unlock new abilities)
  void upgrade() {
    level++;
    miningEfficiency *= 1.2;
    attackPoints += 2;
    defensePoints += 2;
    agilityPoints += 1;

    // Increase max stats and restore current stats to max
    maxHp += 20;
    hp = maxHp;

    maxMp += 10;
    mp = maxMp;

    maxSp += 5;
    sp = maxSp;

    // Increase critical point (e.g., +1% chance per level)
    criticalPoint += 1;

    // Example: Unlock a new ability at certain levels
    if (level == 5) {
      addAbility(AbilitiesModel(
        abilitiesID: "ability_002",
        name: "Heal",
        description: "Restores HP to the user.",
        hpBonus: 20,
        mpCost: 15,
        type: AbilityType.heal,
        targetType: TargetType.single,
        affectsEnemies: false,
        criticalPoint: 15,
      ));
    }
  }

  // Restore stats (optional: reset cooldowns)
  void restoreStats() {
    hp = maxHp;
    mp = maxMp;
    sp = maxSp;
    currentCooldowns.clear(); // Reset all cooldowns
  }
}
