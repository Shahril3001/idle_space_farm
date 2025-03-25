import 'package:hive/hive.dart';
import 'dart:math';
import 'enemy_model.dart';
import 'girl_farmer_model.dart'; // Generated file

part 'ability_model.g.dart';

@HiveType(typeId: 6) // Unique typeId for Hive
class AbilitiesModel {
  @HiveField(0)
  final String abilitiesID; // Unique identifier for the ability

  @HiveField(1)
  final String name; // Name of the ability

  @HiveField(2)
  final String description; // Description of the ability

  @HiveField(3)
  final int attackBonus; // Bonus attack points

  @HiveField(4)
  final int defenseBonus; // Bonus defense points

  @HiveField(5)
  final int hpBonus; // Bonus HP

  @HiveField(6)
  final int agilityBonus; // Bonus agility

  @HiveField(7)
  final int mpCost; // MP cost to use the ability

  @HiveField(8)
  final int spCost; // SP cost to use the ability

  @HiveField(9)
  final int cooldown; // Number of turns before reuse

  @HiveField(10)
  final int criticalPoint; // Critical hit chance or damage multiplier

  @HiveField(11)
  int cooldownTimer = 0; // Tracks remaining cooldown turns

  AbilitiesModel({
    required this.abilitiesID,
    required this.name,
    required this.description,
    this.attackBonus = 0,
    this.defenseBonus = 0,
    this.hpBonus = 0,
    this.agilityBonus = 0,
    this.mpCost = 0,
    this.spCost = 0,
    this.cooldown = 0, // Default to no cooldown
    this.criticalPoint = 0, // Default no critical boost
  });

  // Apply ability effects during battle
  void applyEffect(dynamic target) {
    if (target == null) return;

    // Ensure the target has the required properties
    if (target is GirlFarmer || target is Enemy) {
      target.hp = (target.hp + hpBonus).clamp(0, target.maxHp);
      target.attackPoints += attackBonus;
      target.defensePoints += defenseBonus;
      target.agilityPoints += agilityBonus;
    } else {
      throw ArgumentError("Target must be of type GirlFarmer or Enemy.");
    }
  }

  // Update cooldown timer
  void updateCooldown() {
    if (cooldownTimer > 0) {
      cooldownTimer--;
    }
  }

  // Check if the ability is ready to use
  bool isReady() {
    return cooldownTimer == 0;
  }

  // Use the ability
  bool useAbility(dynamic user, dynamic target) {
    if (user == null || target == null) return false;

    // Check if the ability is on cooldown
    if (!isReady()) {
      print("${name} is on cooldown for $cooldownTimer more turns.");
      return false;
    }

    // Check if the user has enough MP/SP
    if (user.mp < mpCost || user.sp < spCost) {
      print("Not enough MP/SP to use ${name}.");
      return false;
    }

    // Deduct MP/SP and apply cooldown
    user.mp -= mpCost;
    user.sp -= spCost;
    cooldownTimer = cooldown;

    // Apply the ability's effects
    applyEffect(target);
    criticalEffect(target); // Apply critical effect if applicable
    print("${user.name} used ${name} on ${target.name}!");

    return true;
  }

  // Handle critical effects
  void criticalEffect(dynamic target) {
    if (target == null || criticalPoint <= 0) return;

    final random = Random();
    if (random.nextInt(100) < criticalPoint) {
      final criticalDamage =
          (attackBonus * 1.5).toInt(); // Example: 1.5x damage
      target.hp = (target.hp - criticalDamage).clamp(0, target.maxHp);
      print("Critical hit! ${target.name} took $criticalDamage damage.");
    }
  }
}
