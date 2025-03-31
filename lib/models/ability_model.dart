import 'package:hive/hive.dart';
import 'dart:math';
import 'enemy_model.dart';
import 'girl_farmer_model.dart';

part 'ability_model.g.dart';

// ==================== STATUS EFFECT MODELS ====================
@HiveType(typeId: 9)
class StatusEffect {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int duration;

  @HiveField(3)
  final int damagePerTurn;

  @HiveField(4)
  final int attackModifier;

  @HiveField(5)
  final int defenseModifier;

  @HiveField(6)
  final int agilityModifier;

  @HiveField(7)
  final double cooldownRateModifier;

  @HiveField(8)
  ControlEffect? controlEffect;

  @HiveField(9)
  int remainingTurns;

  StatusEffect({
    required this.id,
    required this.name,
    required this.duration,
    this.damagePerTurn = 0,
    this.attackModifier = 0,
    this.defenseModifier = 0,
    this.agilityModifier = 0,
    this.cooldownRateModifier = 1.0,
    this.controlEffect,
  }) : remainingTurns = duration;

  StatusEffect freshCopy() {
    return StatusEffect(
      id: id,
      name: name,
      duration: duration,
      damagePerTurn: damagePerTurn,
      attackModifier: attackModifier,
      defenseModifier: defenseModifier,
      agilityModifier: agilityModifier,
      cooldownRateModifier: cooldownRateModifier,
      controlEffect: controlEffect?.copy(),
    );
  }

  void applyEffect(dynamic target, {dynamic caster}) {
    if (target is! GirlFarmer && target is! Enemy) return;

    if (damagePerTurn > 0) {
      target.hp = (target.hp - damagePerTurn).clamp(0, target.maxHp);
      print("${target.name} takes $damagePerTurn damage from $name!");
    }

    target.attackPoints += attackModifier;
    target.defensePoints += defenseModifier;
    target.agilityPoints += agilityModifier;

    if (controlEffect != null && caster != null) {
      applyControlEffect(target, caster);
    }
  }

  void applyControlEffect(dynamic target, dynamic caster) {
    final rand = Random().nextDouble();
    if (rand > (controlEffect?.successChance ?? 0.0)) return;

    if (target is! Enemy) return;

    switch (controlEffect?.type) {
      case ControlEffectType.taunt:
        target.forcedTarget = caster;
        print("${target.name} is taunted by ${caster.name}!");
        break;
      case ControlEffectType.seduce:
        target.skipNextTurn = true;
        print("${target.name} is seduced and skips turn!");
        break;
      case ControlEffectType.mindControl:
        target.mindControlled = true;
        target.mindController = caster;
        print("${target.name} is mind-controlled!");
        break;
      case null:
      case ControlEffectType.fear:
      case ControlEffectType.charm:
        break;
    }
  }

  void resetStats(dynamic target) {
    if (target is! GirlFarmer && target is! Enemy) return;

    target.attackPoints -= attackModifier;
    target.defensePoints -= defenseModifier;
    target.agilityPoints -= agilityModifier;

    if (controlEffect != null && target is Enemy) {
      switch (controlEffect?.type) {
        case ControlEffectType.taunt:
          target.forcedTarget = null;
          break;
        case ControlEffectType.mindControl:
          target.mindControlled = false;
          target.mindController = null;
          break;
        case null:
        case ControlEffectType.seduce:
        case ControlEffectType.fear:
        case ControlEffectType.charm:
          break;
      }
    }
  }
}

@HiveType(typeId: 10)
class ControlEffect {
  @HiveField(0)
  final ControlEffectType type;

  @HiveField(1)
  final int duration;

  @HiveField(2)
  final double successChance;

  ControlEffect({
    required this.type,
    required this.duration,
    required this.successChance,
  });

  ControlEffect copy() {
    return ControlEffect(
      type: type,
      duration: duration,
      successChance: successChance,
    );
  }
}

@HiveType(typeId: 11)
enum ControlEffectType {
  @HiveField(0)
  taunt,
  @HiveField(1)
  seduce,
  @HiveField(2)
  mindControl,
  @HiveField(3)
  fear,
  @HiveField(4)
  charm
}

// ==================== ELEMENT SYSTEM ====================
@HiveType(typeId: 12)
enum ElementType {
  @HiveField(0)
  none,
  @HiveField(1)
  fire,
  @HiveField(2)
  water,
  @HiveField(3)
  earth,
  @HiveField(4)
  wind,
  @HiveField(5)
  thunder,
  @HiveField(6)
  snow,
  @HiveField(7)
  nature,
  @HiveField(8)
  dark,
  @HiveField(9)
  light,
  @HiveField(10)
  poison,
  @HiveField(11)
  divine,
}

class ElementalSystem {
  static const Map<ElementType, List<ElementType>> strengths = {
    ElementType.fire: [ElementType.nature, ElementType.snow],
    ElementType.water: [ElementType.fire, ElementType.earth],
    ElementType.earth: [ElementType.thunder, ElementType.poison],
    ElementType.wind: [ElementType.water, ElementType.nature],
    ElementType.thunder: [ElementType.water, ElementType.wind],
    ElementType.snow: [ElementType.wind, ElementType.earth],
    ElementType.nature: [ElementType.water, ElementType.earth],
    ElementType.dark: [ElementType.light, ElementType.divine],
    ElementType.light: [ElementType.dark, ElementType.poison],
    ElementType.poison: [ElementType.nature, ElementType.water],
    ElementType.divine: [ElementType.dark, ElementType.poison],
  };

  static const Map<ElementType, List<ElementType>> weaknesses = {
    ElementType.fire: [ElementType.water, ElementType.earth],
    ElementType.water: [ElementType.thunder, ElementType.nature],
    ElementType.earth: [ElementType.water, ElementType.wind],
    ElementType.wind: [ElementType.thunder, ElementType.snow],
    ElementType.thunder: [ElementType.earth, ElementType.divine],
    ElementType.snow: [ElementType.fire, ElementType.light],
    ElementType.nature: [ElementType.fire, ElementType.poison],
    ElementType.dark: [ElementType.light, ElementType.divine],
    ElementType.light: [ElementType.dark, ElementType.divine],
    ElementType.poison: [ElementType.light, ElementType.divine],
    ElementType.divine: [ElementType.none, ElementType.none],
  };

  static double getElementMultiplier(
      ElementType attackElement, List<ElementType> targetElements) {
    if (attackElement == ElementType.none) return 1.0;

    for (final element in targetElements) {
      if (strengths[attackElement]?.contains(element) ?? false) {
        return 1.5;
      }
    }

    for (final element in targetElements) {
      if (weaknesses[attackElement]?.contains(element) ?? false) {
        return 0.5;
      }
    }

    return 1.0;
  }
}

// ==================== MAIN ABILITIES MODEL ====================
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

  @HiveField(15)
  final bool healsCaster;

  @HiveField(16)
  final int healCasterAmount;

  @HiveField(17)
  final bool drainsHealth;

  @HiveField(18)
  final List<StatusEffect> statusEffects;

  @HiveField(19)
  final bool reducesCooldowns;

  @HiveField(20)
  final int cooldownReductionAmount;

  @HiveField(21)
  final double cooldownReductionPercent;

  @HiveField(22)
  final bool affectsAllCooldowns;

  @HiveField(23)
  final ElementType elementType;

  @HiveField(24)
  final int mentalPotency;

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
    this.healsCaster = false,
    this.healCasterAmount = 0,
    this.drainsHealth = false,
    this.statusEffects = const [],
    this.reducesCooldowns = false,
    this.cooldownReductionAmount = 0,
    this.cooldownReductionPercent = 0.0,
    this.affectsAllCooldowns = false,
    this.elementType = ElementType.none,
    this.mentalPotency = 0,
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
      healsCaster: healsCaster,
      healCasterAmount: healCasterAmount,
      drainsHealth: drainsHealth,
      statusEffects: statusEffects.map((e) => e.freshCopy()).toList(),
      reducesCooldowns: reducesCooldowns,
      cooldownReductionAmount: cooldownReductionAmount,
      cooldownReductionPercent: cooldownReductionPercent,
      affectsAllCooldowns: affectsAllCooldowns,
      elementType: elementType,
      mentalPotency: mentalPotency,
    );
  }

  void applyEffect(dynamic target, {dynamic caster}) {
    if (target == null) return;

    // SPECIAL CASE: Holy Light vs Undead
    if (abilitiesID == "ability_016" &&
        target is Enemy &&
        target.type == "undead") {
      target.hp = (target.hp - hpBonus).clamp(0, target.maxHp);
      print("Holy light burns ${target.name} for $hpBonus damage!");
      return;
    }

    double elementMultiplier = 1.0;
    if (elementType != ElementType.none && target is Enemy) {
      elementMultiplier = _getElementMultiplier(target);
      if (elementMultiplier != 1.0) {
        print(
            "${elementType.name.toUpperCase()} is ${elementMultiplier > 1 ? 'strong' : 'weak'} against ${target.name}!");
      }
    }

    if (target is! GirlFarmer && target is! Enemy) {
      throw ArgumentError("Target must be of type GirlFarmer or Enemy.");
    }

    switch (type) {
      case AbilityType.attack:
        final effectiveDamage = (hpBonus * elementMultiplier).round();
        target.hp = (target.hp - effectiveDamage).clamp(0, target.maxHp);

        if (drainsHealth && caster != null && caster is GirlFarmer) {
          caster.hp = (caster.hp + effectiveDamage).clamp(0, caster.maxHp);
          print(
              "${caster.name} drained $effectiveDamage HP from ${target.name}!");
        }
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

      case AbilityType.control:
        break;
    }

    for (final effect in statusEffects) {
      if (target.statusEffects.any((e) => e.id == effect.id)) {
        target.statusEffects
            .firstWhere((e) => e.id == effect.id)
            .remainingTurns = effect.duration;
      } else {
        final adjustedEffect = effect.freshCopy();
        if (adjustedEffect.controlEffect != null && caster != null) {
          final baseChance = adjustedEffect.controlEffect!.successChance;
          final scaledChance = min(0.95, baseChance + (mentalPotency * 0.01));
          adjustedEffect.controlEffect = ControlEffect(
            type: adjustedEffect.controlEffect!.type,
            duration: adjustedEffect.controlEffect!.duration,
            successChance: scaledChance,
          );
        }
        target.statusEffects.add(adjustedEffect);
        adjustedEffect.applyEffect(target, caster: caster);
      }
    }

    if (reducesCooldowns && caster != null && caster is GirlFarmer) {
      if (affectsAllCooldowns) {
        for (final ability in caster.abilities) {
          _reduceCooldown(ability);
        }
      } else {
        _reduceCooldown(this);
      }
    }

    if (healsCaster && caster != null && caster is GirlFarmer) {
      caster.hp = (caster.hp + healCasterAmount).clamp(0, caster.maxHp);
      print("${caster.name} healed $healCasterAmount HP!");
    }
  }

  void _reduceCooldown(AbilitiesModel ability) {
    if (ability.cooldownTimer > 0) {
      final flatReduction = cooldownReductionAmount;
      final percentReduction =
          (ability.cooldownTimer * cooldownReductionPercent).round();
      final totalReduction = flatReduction + percentReduction;
      ability.cooldownTimer = max(0, ability.cooldownTimer - totalReduction);
      print("${ability.name}'s cooldown reduced by $totalReduction turns!");
    }
  }

  double _getElementMultiplier(Enemy target) {
    return ElementalSystem.getElementMultiplier(
        elementType, target.elementAffinities);
  }

  void updateCooldown({double cooldownRate = 1.0}) {
    if (cooldownTimer > 0) {
      final effectiveReduction =
          cooldownRate < 1.0 ? 1 + (1 - cooldownRate) : 1;
      cooldownTimer = max(0, cooldownTimer - effectiveReduction.round());
    }
  }

  bool isReady() => cooldownTimer == 0;

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

    final effectiveTargets =
        targetType == TargetType.all ? targets : [targets.first];

    for (final target in effectiveTargets) {
      if ((affectsEnemies && target is Enemy) ||
          (!affectsEnemies && target is GirlFarmer)) {
        applyEffect(target, caster: user);
        criticalEffect(target, user: user);
      }
    }

    print("${user.name} used ${name}!");
    return true;
  }

  void criticalEffect(dynamic target, {dynamic user}) {
    if (target == null || criticalPoint <= 0) return;

    final random = Random();
    if (random.nextInt(100) < criticalPoint) {
      final criticalMultiplier = type == AbilityType.attack ? 1.5 : 1.2;
      final criticalEffect = (hpBonus * criticalMultiplier).toInt();

      if (type == AbilityType.attack) {
        target.hp = (target.hp - criticalEffect).clamp(0, target.maxHp);
        print("Critical hit! ${target.name} took $criticalEffect damage.");

        if (drainsHealth && user != null && user is GirlFarmer) {
          user.hp = (user.hp + criticalEffect).clamp(0, user.maxHp);
          print("${user.name} drained $criticalEffect HP from critical hit!");
        }
      } else if (type == AbilityType.heal) {
        target.hp = (target.hp + criticalEffect).clamp(0, target.maxHp);
        print("Critical heal! ${target.name} recovered $criticalEffect HP.");
      }
    }
  }

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

  String get elementDescription {
    return elementType == ElementType.none
        ? ""
        : "(${elementType.name.toUpperCase()})";
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
  @HiveField(4)
  control,
}

@HiveType(typeId: 8)
enum TargetType {
  @HiveField(0)
  single,
  @HiveField(1)
  all,
}
