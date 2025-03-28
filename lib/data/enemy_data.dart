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
];

// Boss Enemies
final List<Enemy> bossEnemies = [
  Enemy(
    id: "boss_1",
    name: "Goblin King",
    level: 5,
    attackPoints: 25,
    defensePoints: 18,
    agilityPoints: 12,
    hp: 300,
    maxHp: 300,
    mp: 80,
    sp: 50,
    abilities: [
      AbilitiesModel(
        abilitiesID: "boss_ability_001",
        name: "Royal Cleave",
        description: "Powerful attack that hits all enemies",
        attackBonus: 20,
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
        attackBonus: 10,
        agilityBonus: 8,
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
    attackPoints: 30,
    defensePoints: 15,
    agilityPoints: 10,
    hp: 400,
    maxHp: 400,
    mp: 150,
    sp: 80,
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
        hpBonus: -30, // Damage (negative for heal calculation)
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
    final bool spawnBoss = bossEnemies.isNotEmpty && random.nextDouble() < 0.3;
    final Enemy baseEnemy = spawnBoss
        ? bossEnemies[random.nextInt(bossEnemies.length)]
        : regularEnemies[random.nextInt(regularEnemies.length)];

    enemies.add(Enemy(
      id: '${baseEnemy.id}-${DateTime.now().millisecondsSinceEpoch}-$i',
      name: "$difficulty ${baseEnemy.name}",
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
