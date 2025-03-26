import 'package:hive/hive.dart';
import 'dart:math';
import 'enemy_model.dart';
import 'girl_farmer_model.dart';

part 'ability_model.g.dart';

@HiveType(typeId: 6)
class AbilitiesModel {
  @HiveField(0)
  final String abilitiesID;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int attackBonus;

  @HiveField(4)
  final int defenseBonus;

  @HiveField(5)
  final int hpBonus;

  @HiveField(6)
  final int agilityBonus;

  @HiveField(7)
  final int mpCost;

  @HiveField(8)
  final int spCost;

  @HiveField(9)
  final int cooldown;

  @HiveField(10)
  final int criticalPoint;

  @HiveField(11)
  int cooldownTimer = 0;

  @HiveField(12)
  final AbilityType type;

  @HiveField(13)
  final TargetType targetType;

  @HiveField(14)
  final bool affectsEnemies;

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
    this.cooldown = 0,
    this.criticalPoint = 0,
    required this.type,
    required this.targetType,
    this.affectsEnemies = true,
  });

  AbilitiesModel freshCopy() {
    return AbilitiesModel(
      abilitiesID: abilitiesID,
      name: name,
      description: description,
      attackBonus: attackBonus,
      defenseBonus: defenseBonus,
      hpBonus: hpBonus,
      agilityBonus: agilityBonus,
      mpCost: mpCost,
      spCost: spCost,
      cooldown: cooldown,
      criticalPoint: criticalPoint,
      type: type,
      targetType: targetType,
      affectsEnemies: affectsEnemies,
    );
  }

  // Apply ability effects based on type
  void applyEffect(dynamic target) {
    if (target == null) return;

    if (target is GirlFarmer || target is Enemy) {
      switch (type) {
        case AbilityType.attack:
          // For attacks, hpBonus is treated as damage
          target.hp = (target.hp - hpBonus).clamp(0, target.maxHp);
          break;
        case AbilityType.heal:
          target.hp = (target.hp + hpBonus).clamp(0, target.maxHp);
          break;
        case AbilityType.buff:
          target.attackPoints += attackBonus;
          target.defensePoints += defenseBonus;
          target.agilityPoints += agilityBonus;
          break;
        case AbilityType.debuff:
          target.attackPoints -= attackBonus;
          target.defensePoints -= defenseBonus;
          target.agilityPoints -= agilityBonus;
          break;
      }
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

  // Use the ability on appropriate targets
  bool useAbility(dynamic user, List<dynamic> targets) {
    if (user == null || targets.isEmpty) return false;

    if (!isReady()) {
      print("${name} is on cooldown for $cooldownTimer more turns.");
      return false;
    }

    if (user.mp < mpCost || user.sp < spCost) {
      print("Not enough MP/SP to use ${name}.");
      return false;
    }

    user.mp -= mpCost;
    user.sp -= spCost;
    cooldownTimer = cooldown;

    // Determine which targets to affect
    final effectiveTargets =
        targetType == TargetType.all ? targets : [targets.first];

    for (final target in effectiveTargets) {
      // Verify target is valid for this ability
      if ((affectsEnemies && target is Enemy) ||
          (!affectsEnemies && target is GirlFarmer)) {
        applyEffect(target);
        criticalEffect(target);
      }
    }

    print("${user.name} used ${name}!");
    return true;
  }

  // Handle critical effects
  void criticalEffect(dynamic target) {
    if (target == null || criticalPoint <= 0) return;

    final random = Random();
    if (random.nextInt(100) < criticalPoint) {
      final criticalMultiplier = type == AbilityType.attack ? 1.5 : 1.2;
      final criticalEffect = (hpBonus * criticalMultiplier).toInt();

      if (type == AbilityType.attack) {
        target.hp = (target.hp - criticalEffect).clamp(0, target.maxHp);
        print("Critical hit! ${target.name} took $criticalEffect damage.");
      } else if (type == AbilityType.heal) {
        target.hp = (target.hp + criticalEffect).clamp(0, target.maxHp);
        print("Critical heal! ${target.name} recovered $criticalEffect HP.");
      }
    }
  }

  // Helper method to get targeting description
  String get targetingDescription {
    if (affectsEnemies) {
      return targetType == TargetType.all
          ? "Targets all enemies"
          : "Targets single enemy";
    } else {
      return targetType == TargetType.all
          ? "Targets all allies"
          : "Targets single ally";
    }
  }
}

@HiveType(typeId: 7)
enum AbilityType {
  @HiveField(0)
  attack,
  @HiveField(1)
  heal,
  @HiveField(2)
  buff,
  @HiveField(3)
  debuff,
}

@HiveType(typeId: 8)
enum TargetType {
  @HiveField(0)
  single,
  @HiveField(1)
  all,
}
