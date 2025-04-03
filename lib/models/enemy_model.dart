import 'dart:math';
import 'package:hive/hive.dart';
import 'ability_model.dart';
import 'girl_farmer_model.dart';

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
  @HiveField(19)
  List<ElementType> elementAffinities;

  @HiveField(20)
  List<StatusEffect> statusEffects;

  @HiveField(21)
  dynamic forcedTarget; // For taunt effects

  @HiveField(22)
  bool skipNextTurn; // For seduce effects

  @HiveField(23)
  bool mindControlled; // For mind control

  @HiveField(24)
  dynamic mindController; // Who controls this enemy

  @HiveField(25) // New field number
  final String imageE;

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
    required this.imageE,
    this.maxHp = 100,
    this.maxMp = 50,
    this.maxSp = 30,
    this.criticalPoint = 5,
    this.currentCooldowns = const {},
    this.elementAffinities = const [ElementType.none],
    this.statusEffects = const [],
    this.forcedTarget = null,
    this.skipNextTurn = false,
    this.mindControlled = false,
    this.mindController = null,
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
      imageE: other.imageE,
      maxHp: other.maxHp,
      maxMp: other.maxMp,
      maxSp: other.maxSp,
      criticalPoint: other.criticalPoint,
      elementAffinities: List.from(other.elementAffinities),
      currentCooldowns: {}, // New modifiable map
      statusEffects: [], // New modifiable list
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

  // Add these new methods:
  void processStatusEffects() {
    for (final effect in statusEffects.toList()) {
      effect.applyEffect(this);
      effect.remainingTurns--;

      if (effect.remainingTurns <= 0) {
        effect.resetStats(this);
        statusEffects.remove(effect);
      }
    }
  }

  void processControlEffects(List<GirlFarmer> availableAllies) {
    if (skipNextTurn) {
      skipNextTurn = false;
      return;
    }

    if (mindControlled && mindController != null) {
      // Get valid targets from available allies
      final validTargets = availableAllies.where((a) => a.id != id).toList();
      if (validTargets.isNotEmpty) {
        final target = validTargets[Random().nextInt(validTargets.length)];
        attack(target);
      }
    } else if (forcedTarget != null) {
      attack(forcedTarget);
    }
  }

  void attack(dynamic target) {
    if (target == null) return;

    final damage = max(1, attackPoints - (target.defensePoints ~/ 2));
    target.hp = (target.hp - damage).clamp(0, target.maxHp);
    print("$name attacks ${target.name} for $damage damage!");
  }

  void restoreStats() {
    hp = maxHp;
    mp = maxMp;
    sp = maxSp;
    currentCooldowns.clear();
    statusEffects.clear();
    forcedTarget = null;
    skipNextTurn = false;
    mindControlled = false;
    mindController = null;
  }
}
