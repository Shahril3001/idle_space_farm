// enemy_data.dart
import 'dart:math';
import '../models/ability_model.dart';
import '../models/enemy_model.dart';

final List<Enemy> baseEnemies = [
  Enemy(
    id: "1",
    name: "Goblin",
    level: 1,
    attackPoints: 10,
    defensePoints: 5,
    agilityPoints: 7,
    hp: 50,
    maxHp: 50, // Added maxHp
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
    maxHp: 80, // Added maxHp
    mp: 30,
    sp: 20,
    abilities: [
      AbilitiesModel(
        abilitiesID: "ability_002",
        name: "Bash",
        description: "A powerful strike that stuns the enemy",
        attackBonus: 10,
        mpCost: 5,
        cooldown: 3,
        type: AbilityType.attack,
        targetType: TargetType.single,
        affectsEnemies: true,
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
    maxHp: 60, // Added maxHp
    mp: 50,
    sp: 30,
    abilities: [
      AbilitiesModel(
        abilitiesID: "ability_003",
        name: "Fireball",
        description: "Launches a fiery projectile",
        attackBonus: 15,
        mpCost: 8,
        cooldown: 4,
        type: AbilityType.attack,
        targetType: TargetType.all,
        affectsEnemies: true,
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
    name: "Orc",
    level: 1,
    attackPoints: 15,
    defensePoints: 10,
    agilityPoints: 5,
    hp: 80,
    maxHp: 80, // Added maxHp
    mp: 30,
    sp: 20,
    abilities: [
      AbilitiesModel(
        abilitiesID: "ability_002",
        name: "Bash",
        description: "A powerful strike that stuns the enemy",
        attackBonus: 10,
        mpCost: 5,
        cooldown: 3,
        type: AbilityType.attack,
        targetType: TargetType.single,
        affectsEnemies: true,
      ),
    ],
    rarity: "Common",
    type: "Warrior",
    region: "Forest",
    description: "A strong and tough monster",
    criticalPoint: 15,
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

  final random = Random();
  final enemies = <Enemy>[];
  final difficultyMultiplier = _getDifficultyMultiplier(difficulty);
  final levelScale = 1 + (log(dungeonLevel) * 0.5);

  for (int i = 0; i < _getEnemyCount(difficulty); i++) {
    final baseEnemy = availableEnemies[random.nextInt(availableEnemies.length)];

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
