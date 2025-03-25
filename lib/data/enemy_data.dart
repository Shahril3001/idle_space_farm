// enemy_data.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/ability_model.dart';
import '../models/enemy_model.dart';

final List<Enemy> enemiesData = [
  Enemy(
    id: "1",
    name: "Goblin",
    level: 1,
    attackPoints: 10,
    defensePoints: 5,
    agilityPoints: 7,
    hp: 50,
    mp: 20,
    sp: 10,
    abilities: [
      AbilitiesModel(
        abilitiesID: "ability_001",
        name: "Slash",
        description: "A basic melee attack.",
        attackBonus: 5,
        mpCost: 3,
        cooldown: 2,
      ),
    ],
    rarity: "Common",
    type: "Fighter",
    region: "Forest",
    description: "A weak but agile monster.",
  ),
  Enemy(
    id: "2",
    name: "Orc",
    level: 3,
    attackPoints: 15,
    defensePoints: 10,
    agilityPoints: 5,
    hp: 80,
    mp: 30,
    sp: 20,
    abilities: [
      AbilitiesModel(
        abilitiesID: "ability_002",
        name: "Bash",
        description: "A powerful strike that stuns the enemy.",
        attackBonus: 10,
        mpCost: 5,
        cooldown: 3,
      ),
    ],
    rarity: "Common",
    type: "Warrior",
    region: "Mountain",
    description: "A strong and tough monster.",
  ),
  // Add more enemies here
];

// Function to generate enemies based on level and difficulty
List<Enemy> generateEnemies(int dungeonLevel, String difficulty) {
  final random = Random();
  final List<Enemy> enemies = [];

  // Adjust stats based on difficulty
  double statMultiplier = 1.0;
  switch (difficulty) {
    case "Easy":
      statMultiplier = 0.8;
      break;
    case "Medium":
      statMultiplier = 1.0;
      break;
    case "Hard":
      statMultiplier = 1.5;
      break;
  }

  for (int i = 0; i < 5; i++) {
    final baseEnemy = enemiesData[random.nextInt(enemiesData.length)];
    final enemy = Enemy(
      id: "${baseEnemy.id}-$i",
      name: baseEnemy.name,
      level: dungeonLevel,
      attackPoints:
          (baseEnemy.attackPoints * statMultiplier * dungeonLevel).toInt(),
      defensePoints:
          (baseEnemy.defensePoints * statMultiplier * dungeonLevel).toInt(),
      agilityPoints:
          (baseEnemy.agilityPoints * statMultiplier * dungeonLevel).toInt(),
      hp: (baseEnemy.hp * statMultiplier * dungeonLevel).toInt(),
      mp: (baseEnemy.mp * statMultiplier * dungeonLevel).toInt(),
      sp: (baseEnemy.sp * statMultiplier * dungeonLevel).toInt(),
      abilities: baseEnemy.abilities,
      rarity: baseEnemy.rarity,
      type: baseEnemy.type,
      region: baseEnemy.region,
      description: baseEnemy.description,
    );
    enemies.add(enemy);
  }

  return enemies;
}
