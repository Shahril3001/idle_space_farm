// enemy_data.dart
import 'dart:math';
import '../models/ability_model.dart';
import '../models/enemy_model.dart';

final List<Enemy> baseEnemies = [
  // Common Enemies
  Enemy(
    id: "1",
    name: "Goblin",
    level: 1,
    attackPoints: 10,
    defensePoints: 5,
    agilityPoints: 7,
    hp: 50,
    maxHp: 50,
    mp: 20,
    sp: 10,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "ability_001",
        name: "Slash",
        description: "A basic melee attack",
        attackBonus: 5,
        mpCost: 3,
        cooldown: 2,
        type: AbilityType.attack,
        targetType: TargetType.single,
        affectsEnemies: true,
        criticalPoint: 10,
      ),
      AbilitiesModel(
        abilitiesID: "ability_002",
        name: "Dodge",
        description: "Increases evasion for next attack",
        agilityBonus: 15,
        mpCost: 5,
        cooldown: 3,
        type: AbilityType.buff,
        targetType: TargetType.single,
        affectsEnemies: false,
        criticalPoint: 0,
      ),
    ],
    rarity: "Common",
    type: "Fighter",
    region: "Forest",
    description: "A weak but agile monster",
    criticalPoint: 10,
  ),
  Enemy(
    id: "2",
    name: "Orc",
    level: 1,
    attackPoints: 15,
    defensePoints: 10,
    agilityPoints: 5,
    hp: 80,
    maxHp: 80,
    mp: 30,
    sp: 20,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "ability_003",
        name: "Bash",
        description: "A powerful strike",
        attackBonus: 10,
        hpBonus: 10, // Additional damage
        mpCost: 5,
        cooldown: 3,
        type: AbilityType.attack,
        targetType: TargetType.single,
        affectsEnemies: true,
        criticalPoint: 15,
      ),
    ],
    rarity: "Common",
    type: "Warrior",
    region: "Mountain",
    description: "A strong and tough monster",
    criticalPoint: 15,
  ),
  Enemy(
    id: "3",
    name: "Dark Mage",
    level: 1,
    attackPoints: 12,
    defensePoints: 3,
    agilityPoints: 8,
    hp: 60,
    maxHp: 60,
    mp: 50,
    sp: 30,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "ability_004",
        name: "Fireball",
        description: "Launches a fiery projectile",
        attackBonus: 15,
        hpBonus: 15, // Damage value
        mpCost: 8,
        cooldown: 4,
        type: AbilityType.attack,
        targetType: TargetType.all,
        affectsEnemies: true,
        criticalPoint: 20,
      ),
      AbilitiesModel(
        abilitiesID: "ability_005",
        name: "Dark Pact",
        description: "Sacrifices HP to restore MP",
        hpBonus: -20, // HP cost
        mpCost: 0,
        cooldown: 5,
        type: AbilityType.heal,
        targetType: TargetType.single,
        affectsEnemies: false,
        criticalPoint: 0,
      ),
    ],
    rarity: "Uncommon",
    type: "Mage",
    region: "Ruins",
    description: "A spellcaster with dark powers",
    criticalPoint: 20,
  ),
  Enemy(
    id: "4",
    name: "Forest Spider",
    level: 1,
    attackPoints: 8,
    defensePoints: 6,
    agilityPoints: 9,
    hp: 45,
    maxHp: 45,
    mp: 15,
    sp: 25,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "ability_006",
        name: "Venom Bite",
        description: "Poisonous attack",
        attackBonus: 7,
        hpBonus: 8, // Damage
        mpCost: 4,
        cooldown: 3,
        type: AbilityType.attack,
        targetType: TargetType.single,
        affectsEnemies: true,
        criticalPoint: 12,
      ),
      AbilitiesModel(
        abilitiesID: "ability_007",
        name: "Web Shot",
        description: "Reduces enemy agility",
        agilityBonus: -5, // Debuff
        mpCost: 6,
        cooldown: 4,
        type: AbilityType.debuff,
        targetType: TargetType.single,
        affectsEnemies: true,
        criticalPoint: 0,
      ),
    ],
    rarity: "Common",
    type: "Beast",
    region: "Forest",
    description: "A venomous arachnid that lurks in trees",
    criticalPoint: 12,
  ),
  Enemy(
    id: "undead_001",
    name: "Zombie",
    type: "undead",
    level: 3,
    attackPoints: 12,
    defensePoints: 8,
    agilityPoints: 4,
    hp: 50,
    maxHp: 50,
    mp: 0,
    sp: 20,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "undead_001",
        name: "Rotting Claw",
        description: "A disease-ridden attack",
        hpBonus: 8,
        mpCost: 0,
        cooldown: 0,
        type: AbilityType.attack,
        targetType: TargetType.single,
        affectsEnemies: true,
      ),
    ],
    rarity: "Common",
    region: "Tomb",
    description: "Shambling corpse with a hunger for flesh",
    criticalPoint: 10,
  ),

  Enemy(
    id: "undead_002",
    name: "Skeleton Archer",
    type: "undead",
    level: 5,
    attackPoints: 18,
    defensePoints: 6,
    agilityPoints: 12,
    hp: 40,
    maxHp: 40,
    mp: 10,
    sp: 30,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "undead_002",
        name: "Bone Arrow",
        description: "Piercing attack that ignores some defense",
        hpBonus: 12,
        defenseBonus: -3, // Reduces target's defense
        mpCost: 5,
        cooldown: 2,
        type: AbilityType.attack,
        targetType: TargetType.single,
        affectsEnemies: true,
      ),
    ],
    rarity: "Uncommon",
    region: "Tomb",
    description: "Animated skeleton with deadly aim",
    criticalPoint: 20,
  ),

  Enemy(
    id: "undead_003",
    name: "Wraith",
    type: "undead",
    level: 7,
    attackPoints: 15,
    defensePoints: 5,
    agilityPoints: 15,
    hp: 60,
    maxHp: 60,
    mp: 30,
    sp: 25,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "undead_003",
        name: "Soul Chill",
        description: "Drains warmth from the living",
        hpBonus: 10,
        agilityBonus: -5, // Slows target
        mpCost: 8,
        cooldown: 3,
        type: AbilityType.debuff,
        targetType: TargetType.single,
        affectsEnemies: true,
      ),
    ],
    rarity: "Rare",
    region: "Tomb",
    description: "Spectral entity that chills the air around it",
    criticalPoint: 15,
  ),

  Enemy(
    id: "undead_004",
    name: "Ghoul",
    type: "undead",
    level: 8,
    attackPoints: 22,
    defensePoints: 10,
    agilityPoints: 8,
    hp: 80,
    maxHp: 80,
    mp: 15,
    sp: 40,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "undead_004",
        name: "Cannibalize",
        description: "Heals by consuming flesh",
        hpBonus: 25,
        mpCost: 10,
        cooldown: 4,
        type: AbilityType.heal,
        targetType: TargetType.single,
        affectsEnemies: false,
        drainsHealth: true, // Heals based on damage dealt
      ),
    ],
    rarity: "Uncommon",
    region: "Tomb",
    description: "Flesh-eating monstrosity that regenerates",
    criticalPoint: 15,
  ),

  Enemy(
    id: "undead_005",
    name: "Vampire Spawn",
    type: "undead",
    level: 12,
    attackPoints: 28,
    defensePoints: 14,
    agilityPoints: 18,
    hp: 100,
    maxHp: 100,
    mp: 40,
    sp: 50,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "undead_005",
        name: "Blood Drain",
        description: "Steals life essence",
        hpBonus: 20,
        mpCost: 15,
        cooldown: 3,
        type: AbilityType.attack,
        targetType: TargetType.single,
        affectsEnemies: true,
        drainsHealth: true,
      ),
      AbilitiesModel(
        abilitiesID: "undead_006",
        name: "Mist Form",
        description: "Temporarily becomes invulnerable",
        agilityBonus: 10,
        mpCost: 20,
        cooldown: 6,
        type: AbilityType.buff,
        targetType: TargetType.single,
        affectsEnemies: false,
      ),
    ],
    rarity: "Rare",
    region: "Tomb",
    description: "Lesser vampire with a thirst for blood",
    criticalPoint: 25,
  ),
  Enemy(
    id: "void_1",
    name: "Void Pawn",
    type: "void",
    level: 5,
    attackPoints: 18,
    defensePoints: 8,
    agilityPoints: 12,
    hp: 120,
    maxHp: 120,
    mp: 30,
    sp: 40,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "void_001",
        name: "Null Touch",
        description: "Drains energy from target",
        hpBonus: 15,
        mpCost: 10,
        cooldown: 2,
        type: AbilityType.attack,
        targetType: TargetType.single,
        affectsEnemies: true,
        drainsHealth: true,
      ),
    ],
    rarity: "Common",
    region: "Void Rift",
    description: "A fragment of the Void's hunger given form",
    criticalPoint: 10,
  ),
  Enemy(
    id: "void_2",
    name: "Void Reaver",
    type: "void",
    level: 12,
    attackPoints: 35,
    defensePoints: 20,
    agilityPoints: 18,
    hp: 300,
    maxHp: 300,
    mp: 100,
    sp: 80,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "void_002",
        name: "Oblivion Wave",
        description: "Deals damage and reduces MP",
        hpBonus: 25,
        mpCost: 20,
        cooldown: 3,
        type: AbilityType.attack,
        targetType: TargetType.all,
        affectsEnemies: true, // You'll need to handle this in applyEffect
      ),
      AbilitiesModel(
        abilitiesID: "void_003",
        name: "Event Horizon",
        description: "Reduces all stats of enemies",
        attackBonus: -10,
        defenseBonus: -10,
        agilityBonus: -10,
        mpCost: 30,
        cooldown: 5,
        type: AbilityType.debuff,
        targetType: TargetType.all,
        affectsEnemies: true,
      ),
    ],
    rarity: "Elite",
    region: "Void Rift",
    description: "A swirling mass of anti-existence",
    criticalPoint: 20,
  ),
];

// Boss Enemies
final List<Enemy> bossEnemies = [
  Enemy(
    id: "boss_1",
    name: "Goblin King",
    level: 20,
    attackPoints: 30,
    defensePoints: 20,
    agilityPoints: 20,
    hp: 500,
    maxHp: 500,
    mp: 100,
    sp: 100,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "boss_ability_001",
        name: "Royal Cleave",
        description: "Powerful attack that hits all enemies",
        attackBonus: 100,
        hpBonus: 25, // Damage
        mpCost: 15,
        cooldown: 4,
        type: AbilityType.attack,
        targetType: TargetType.all,
        affectsEnemies: true,
        criticalPoint: 15,
      ),
      AbilitiesModel(
        abilitiesID: "boss_ability_002",
        name: "Battle Frenzy",
        description: "Increases attack and agility",
        attackBonus: 15,
        agilityBonus: 10,
        mpCost: 15,
        cooldown: 5,
        type: AbilityType.buff,
        targetType: TargetType.single,
        affectsEnemies: false,
        criticalPoint: 0,
      ),
    ],
    rarity: "Boss",
    type: "Fighter",
    region: "Forest",
    description: "The tyrannical ruler of the goblin horde",
    criticalPoint: 15,
  ),
  Enemy(
    id: "boss_2",
    name: "Lich",
    level: 10,
    attackPoints: 40,
    defensePoints: 20,
    agilityPoints: 25,
    hp: 600,
    maxHp: 600,
    mp: 200,
    sp: 100,
    imageE: 'assets/images/enemies/pawn-goblin.png',
    abilities: [
      AbilitiesModel(
        abilitiesID: "boss_ability_003",
        name: "Death Bolt",
        description: "Dark magic that deals heavy damage",
        attackBonus: 35,
        hpBonus: 40, // Damage
        mpCost: 20,
        cooldown: 3,
        type: AbilityType.attack,
        targetType: TargetType.single,
        affectsEnemies: true,
        criticalPoint: 25,
      ),
      AbilitiesModel(
        abilitiesID: "boss_ability_004",
        name: "Life Drain",
        description: "Steals HP from enemy",
        attackBonus: 15,
        hpBonus: -50, // Damage (negative for heal calculation)
        mpCost: 25,
        cooldown: 5,
        type: AbilityType.heal, // Will be handled specially in applyEffect
        targetType: TargetType.single,
        affectsEnemies: true,
        criticalPoint: 20,
      ),
    ],
    rarity: "Boss",
    type: "Undead",
    region: "Graveyard",
    description: "A powerful undead sorcerer",
    criticalPoint: 25,
  ),
];

List<Enemy> generateEnemies(
  int dungeonLevel,
  String difficulty, {
  required String region,
}) {
  final regionalEnemies = baseEnemies.where((e) => e.region == region).toList();
  final availableEnemies =
      regionalEnemies.isNotEmpty ? regionalEnemies : baseEnemies;

  // Separate boss enemies from regular enemies
  final regularEnemies =
      availableEnemies.where((e) => e.rarity != "Boss").toList();
  final bossEnemies =
      availableEnemies.where((e) => e.rarity == "Boss").toList();

  final random = Random();
  final enemies = <Enemy>[];
  final difficultyMultiplier = _getDifficultyMultiplier(difficulty);
  final levelScale = 1 + (log(dungeonLevel) * 0.5);

  for (int i = 0; i < _getEnemyCount(difficulty); i++) {
    // 30% chance to spawn a boss if available, otherwise regular enemy
    final bool spawnBoss = bossEnemies.isNotEmpty && random.nextDouble() < 0.9;
    final Enemy baseEnemy = spawnBoss
        ? bossEnemies[random.nextInt(bossEnemies.length)]
        : regularEnemies[random.nextInt(regularEnemies.length)];

    enemies.add(Enemy(
      id: '${baseEnemy.id}-${DateTime.now().millisecondsSinceEpoch}-$i',
      name: "$difficulty ${baseEnemy.name}",
      imageE: baseEnemy.imageE, //
      level: dungeonLevel,
      attackPoints:
          (baseEnemy.attackPoints * difficultyMultiplier * levelScale).round(),
      defensePoints:
          (baseEnemy.defensePoints * difficultyMultiplier * levelScale).round(),
      agilityPoints:
          (baseEnemy.agilityPoints * difficultyMultiplier * levelScale).round(),
      hp: (baseEnemy.maxHp * difficultyMultiplier * levelScale).round(),
      maxHp: (baseEnemy.maxHp * difficultyMultiplier * levelScale).round(),
      mp: (baseEnemy.maxMp * difficultyMultiplier).round(),
      maxMp: (baseEnemy.maxMp * difficultyMultiplier).round(),
      sp: baseEnemy.sp,
      maxSp: baseEnemy.maxSp,
      abilities: baseEnemy.abilities.map((a) => a.freshCopy()).toList(),
      rarity: baseEnemy.rarity,
      type: baseEnemy.type,
      region: region,
      description: baseEnemy.description,
      criticalPoint: baseEnemy.criticalPoint,
      currentCooldowns: {},
    ));
  }

  return enemies;
}

double _getDifficultyMultiplier(String difficulty) {
  return const {
        'Easy': 0.8,
        'Medium': 1.0,
        'Hard': 1.5,
      }[difficulty] ??
      1.0;
}

int _getEnemyCount(String difficulty) {
  return const {
        'Easy': 2,
        'Medium': 3,
        'Hard': 4,
      }[difficulty] ??
      3;
}

// Helper function to get enemy by ID
Enemy? getEnemyById(String id) {
  return baseEnemies.firstWhere((enemy) => enemy.id == id);
}
