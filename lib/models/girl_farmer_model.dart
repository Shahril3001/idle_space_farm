import 'dart:math';
import 'package:hive/hive.dart';
import 'ability_model.dart';

part 'girl_farmer_model.g.dart';

@HiveType(typeId: 2)
class GirlFarmer {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int level;

  @HiveField(3)
  double miningEfficiency;

  @HiveField(4)
  String? assignedFarm;

  @HiveField(5)
  String rarity;

  @HiveField(6)
  int stars;

  @HiveField(7)
  String image;

  @HiveField(8)
  String imageFace;

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
  List<AbilitiesModel> abilities;

  @HiveField(16)
  String race;

  @HiveField(17)
  String type;

  @HiveField(18)
  String region;

  @HiveField(19)
  String description;

  @HiveField(20)
  int maxHp;

  @HiveField(21)
  int maxMp;

  @HiveField(22)
  int maxSp;

  @HiveField(23)
  int criticalPoint;

  @HiveField(24)
  Map<String, int> _cooldownsStorage; // Private storage for Hive

  @HiveField(25)
  List<ElementType> elementAffinities;

  @HiveField(26)
  List<StatusEffect> statusEffects;

  @HiveField(27)
  dynamic forcedTarget;

  @HiveField(28)
  bool skipNextTurn;

  @HiveField(29)
  bool mindControlled;

  @HiveField(30)
  dynamic mindController;

  @HiveField(31)
  List<String> partyMemberIds;

  // Public getter that returns a mutable copy

// To (more efficient version):
  Map<String, int> get currentCooldowns {
    return _cooldownsStorage.isEmpty
        ? <String, int>{}
        : Map<String, int>.from(_cooldownsStorage);
  }

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
    this.abilities = const [],
    required this.race,
    required this.type,
    required this.region,
    this.description = "A skilled farmer with a strong connection to the land.",
    this.maxHp = 100,
    this.maxMp = 50,
    this.maxSp = 30,
    this.criticalPoint = 5,
    Map<String, int> currentCooldowns = const {},
    this.elementAffinities = const [ElementType.none],
    this.statusEffects = const [],
    this.forcedTarget = null,
    this.skipNextTurn = false,
    this.mindControlled = false,
    this.mindController = null,
    this.partyMemberIds = const [],
  }) : _cooldownsStorage = Map<String, int>.from(currentCooldowns);

  List<GirlFarmer> get partyMembers {
    // Implement your party member resolution logic here
    return [];
  }

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
      hp: maxHp,
      mp: maxMp,
      sp: maxSp,
      abilities: abilities.map((a) => a.freshCopy()).toList(),
      race: race,
      type: type,
      region: region,
      description: description,
      maxHp: maxHp,
      maxMp: maxMp,
      maxSp: maxSp,
      criticalPoint: criticalPoint,
      currentCooldowns: {}, // This creates a new modifiable map
      statusEffects: [], // This creates a new modifiable list
      elementAffinities: List.from(elementAffinities),
      partyMemberIds: List.from(partyMemberIds),
    );
  }

  void addAbility(AbilitiesModel ability) {
    abilities.add(ability);
  }

  void removeAbility(String abilitiesID) {
    abilities.removeWhere((ability) => ability.abilitiesID == abilitiesID);
  }

  bool useAbility(AbilitiesModel ability, dynamic target) {
    if (!abilities.contains(ability)) {
      print("${name} does not know ${ability.name}.");
      return false;
    }

    if ((_cooldownsStorage[ability.abilitiesID] ?? 0) > 0) {
      print(
          "${ability.name} is on cooldown for ${_cooldownsStorage[ability.abilitiesID]} more turns.");
      return false;
    }

    final success = ability.useAbility(this, target);
    if (success) {
      _updateCooldown(ability.abilitiesID, ability.cooldown);
    }
    return success;
  }

  void updateCooldowns() {
    final updated = Map<String, int>.from(_cooldownsStorage);
    updated.updateAll((id, cooldown) => cooldown > 0 ? cooldown - 1 : 0);
    _cooldownsStorage = updated;
  }

  void upgrade() {
    level++;
    miningEfficiency *= 1.2;
    attackPoints += 2;
    defensePoints += 2;
    agilityPoints += 1;

    maxHp += 20;
    hp = maxHp;

    maxMp += 10;
    mp = maxMp;

    maxSp += 5;
    sp = maxSp;

    criticalPoint += 1;

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
    _cooldownsStorage = {};
    statusEffects.clear();
    forcedTarget = null;
    skipNextTurn = false;
    mindControlled = false;
    mindController = null;
  }

  /// Public method to set a cooldown
  void setCooldown(String abilityId, int value) {
    _updateCooldown(abilityId, value); // Reuse existing private method
  }

  /// Public method to clear all cooldowns
  void clearCooldowns() {
    _cooldownsStorage.clear();
  }

  /// Public method to get a specific cooldown value
  int getCooldown(String abilityId) {
    return _cooldownsStorage[abilityId] ?? 0;
  }

  // Private method to safely update cooldowns
  // This should remain as is:
  void _updateCooldown(String abilityId, int value) {
    final updated = Map<String, int>.from(_cooldownsStorage);
    updated[abilityId] = value;
    _cooldownsStorage = updated;
  }
}
