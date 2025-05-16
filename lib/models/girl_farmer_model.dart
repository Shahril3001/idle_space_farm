import 'dart:math';
import 'package:hive/hive.dart';
import 'ability_model.dart';
import 'equipment_model.dart';

part 'girl_farmer_model.g.dart';

@HiveType(typeId: 2)
class GirlFarmer {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int level;

  @HiveField(3)
  double miningEfficiency;

  @HiveField(4)
  String? assignedFarm;

  @HiveField(5)
  final String rarity;

  @HiveField(6)
  int stars;

  @HiveField(7)
  final String image;

  @HiveField(8)
  final String imageFace;

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
  final String race;

  @HiveField(17)
  final String type;

  @HiveField(18)
  final String region;

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
  Map<String, int> _cooldownsStorage;

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

  @HiveField(32)
  bool isUntargetable;

  @HiveField(33) // Use next available number
  List<Equipment> equippedItems = [];

  Map<String, int> get currentCooldowns => Map.from(_cooldownsStorage);

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
    this.forcedTarget,
    this.skipNextTurn = false,
    this.mindControlled = false,
    this.mindController,
    this.partyMemberIds = const [],
    this.isUntargetable = false,
    this.equippedItems = const [],
  }) : _cooldownsStorage = Map.from(currentCooldowns);

  /// Resolves party members from a list of all available girl farmers
  List<GirlFarmer> getPartyMembers(List<GirlFarmer> allGirlFarmers) {
    return partyMemberIds.map((id) {
      try {
        return allGirlFarmers.firstWhere((girl) => girl.id == id);
      } catch (e) {
        throw Exception('Party member not found: $id');
      }
    }).toList();
  }

  /// Checks if a specific girl farmer is in the party
  bool isInParty(String girlFarmerId) => partyMemberIds.contains(girlFarmerId);

  /// Adds a member to the party
  void addPartyMember(String girlFarmerId) {
    if (!partyMemberIds.contains(girlFarmerId)) {
      partyMemberIds = List.from(partyMemberIds)..add(girlFarmerId);
    }
  }

  /// Removes a member from the party
  void removePartyMember(String girlFarmerId) {
    partyMemberIds = List.from(partyMemberIds)..remove(girlFarmerId);
  }

  /// Creates a fresh copy with reset stats
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
      currentCooldowns: {},
      statusEffects: [],
      elementAffinities: List.from(elementAffinities),
      partyMemberIds: List.from(partyMemberIds),
      equippedItems: List.from(equippedItems),
    );
  }

  /// Adds a new ability
  void addAbility(AbilitiesModel ability) {
    if (!abilities.any((a) => a.abilitiesID == ability.abilitiesID)) {
      abilities.add(ability);
    }
  }

  /// Removes an ability
  void removeAbility(String abilityId) {
    abilities.removeWhere((a) => a.abilitiesID == abilityId);
  }

  /// Uses an ability with party awareness
  bool useAbility(AbilitiesModel ability, dynamic target,
      {List<GirlFarmer>? allPartyMembers}) {
    if (!abilities.contains(ability)) {
      print("$name doesn't know ${ability.name}");
      return false;
    }

    if (getCooldown(ability.abilitiesID) > 0) {
      print("${ability.name} is on cooldown");
      return false;
    }

    // Handle party-based abilities
    if (ability.abilitiesID == "therian_003" && allPartyMembers != null) {
      target = getPartyMembers(allPartyMembers);
    }

    final success = ability.useAbility(this, target);
    if (success) {
      setCooldown(ability.abilitiesID, ability.cooldown);
    }
    return success;
  }

  /// Updates all cooldowns
  void updateCooldowns() {
    _cooldownsStorage =
        _cooldownsStorage.map((k, v) => MapEntry(k, max(0, v - 1)));
  }

  /// Levels up the character
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

  /// Processes status effects
  void processStatusEffects() {
    statusEffects.removeWhere((effect) {
      effect.applyEffect(this);
      effect.remainingTurns--;
      if (effect.remainingTurns <= 0) {
        effect.resetStats(this);
        return true;
      }
      return false;
    });
  }

  /// Processes control effects
  void processControlEffects(List<GirlFarmer> availableAllies) {
    if (skipNextTurn) {
      skipNextTurn = false;
      return;
    }

    if (mindControlled && mindController != null) {
      final validTargets = availableAllies.where((a) => a.id != id).toList();
      if (validTargets.isNotEmpty) {
        attack(validTargets[Random().nextInt(validTargets.length)]);
      }
    } else if (forcedTarget != null) {
      attack(forcedTarget);
    }
  }

  /// Basic attack
  void attack(dynamic target) {
    if (target == null) return;
    final damage = max(1, attackPoints - (target.defensePoints ~/ 2));
    target.hp = (target.hp - damage).clamp(0, target.maxHp);
    print("$name attacks ${target.name} for $damage damage!");
  }

  /// Resets all stats
  void restoreStats() {
    hp = maxHp;
    mp = maxMp;
    sp = maxSp;
    _cooldownsStorage.clear();
    statusEffects.clear();
    forcedTarget = null;
    skipNextTurn = false;
    mindControlled = false;
    mindController = null;
    isUntargetable = false;
  }

  // Cooldown management
  void setCooldown(String abilityId, int value) {
    _cooldownsStorage[abilityId] = value;
  }

  void clearCooldowns() => _cooldownsStorage.clear();

  int getCooldown(String abilityId) => _cooldownsStorage[abilityId] ?? 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'miningEfficiency': miningEfficiency,
      'rarity': rarity,
      'stars': stars,
      'image': image,
      'imageFace': imageFace,
      'attackPoints': attackPoints,
      'defensePoints': defensePoints,
      'agilityPoints': agilityPoints,
      'hp': hp,
      'mp': mp,
      'sp': sp,
      'maxHp': maxHp,
      'maxMp': maxMp,
      'maxSp': maxSp,
      'criticalPoint': criticalPoint,
      'abilities': abilities.map((a) => a.toMap()).toList(),
      'race': race,
      'type': type,
      'region': region,
      'description': description,
    };
  }

  factory GirlFarmer.fromMap(Map<String, dynamic> map) {
    return GirlFarmer(
      id: map['id'] as String,
      name: map['name'] as String,
      level: map['level'] as int,
      miningEfficiency: map['miningEfficiency'] as double,
      rarity: map['rarity'] as String,
      stars: map['stars'] as int,
      image: map['image'] as String,
      imageFace: map['imageFace'] as String,
      attackPoints: map['attackPoints'] as int,
      defensePoints: map['defensePoints'] as int,
      agilityPoints: map['agilityPoints'] as int,
      hp: map['hp'] as int,
      mp: map['mp'] as int,
      sp: map['sp'] as int,
      maxHp: map['maxHp'] as int,
      maxMp: map['maxMp'] as int,
      maxSp: map['maxSp'] as int,
      abilities: (map['abilities'] as List)
          .map((a) => AbilitiesModel.fromMap(a as Map<String, dynamic>))
          .toList(),
      race: map['race'] as String,
      type: map['type'] as String,
      region: map['region'] as String,
      description: map['description'] as String,
    )..criticalPoint = map['criticalPoint'] as int;
  }

  /// Attempts to equip an item with validation
  /// Returns [true] if successful
  bool tryEquip(Equipment item) {
    if (!_canEquip(item)) return false;

    // Unequip existing slot item if needed
    final existing = getItemInSlot(item.slot);
    if (existing != null) unequipItem(existing);

    equipItem(item);
    return true;
  }

  /// Core equip logic (assumes validation already passed)
  void equipItem(Equipment item) {
    equippedItems.add(item);
    _applyItemStats(item);
  }

  /// Unequips an item if equipped
  void unequipItem(Equipment item) {
    if (equippedItems.remove(item)) {
      _removeItemStats(item);
    }
  }

  /// Gets item in a specific slot
  Equipment? getItemInSlot(EquipmentSlot slot) {
    try {
      return equippedItems.firstWhere((e) => e.slot == slot);
    } catch (e) {
      return null;
    }
  }

// Private helpers
  bool _canEquip(Equipment item) {
    return item.allowedTypes.isEmpty || item.allowedTypes.contains(type);
  }

  void _applyItemStats(Equipment item) {
    maxHp += item.scaledHp;
    hp += item.scaledHp;
    attackPoints += item.scaledAttack;
    defensePoints += item.scaledDefense;
    agilityPoints += item.scaledAgility;
  }

  void _removeItemStats(Equipment item) {
    maxHp -= item.scaledHp;
    hp = hp.clamp(0, maxHp);
    attackPoints -= item.scaledAttack;
    defensePoints -= item.scaledDefense;
    agilityPoints -= item.scaledAgility;
  }

// Get total bonuses for display
  Map<String, int> get equipmentBonuses {
    return {
      'attack': equippedItems.fold(0, (sum, item) => sum + item.scaledAttack),
      'defense': equippedItems.fold(0, (sum, item) => sum + item.scaledDefense),
      'hp': equippedItems.fold(0, (sum, item) => sum + item.scaledHp),
      'agility': equippedItems.fold(0, (sum, item) => sum + item.scaledAgility),
    };
  }
}

@HiveType(typeId: 28)
enum CharacterType {
  @HiveField(0)
  warrior,
  @HiveField(1)
  archmage,
  @HiveField(2)
  assassin,
  @HiveField(3)
  cleric,
  @HiveField(4)
  paladin,
  @HiveField(5)
  elementalist,
  @HiveField(6)
  berserker,
  @HiveField(7)
  archer,
  @HiveField(8)
  unknown,
}

@HiveType(typeId: 29)
enum CharacterRace {
  @HiveField(0)
  human,
  @HiveField(1)
  elves,
  @HiveField(2)
  daemon,
  @HiveField(3)
  beastkin,
  @HiveField(4)
  dragonkin,
  @HiveField(5)
  celestial,
  @HiveField(6)
  unknown,
}
