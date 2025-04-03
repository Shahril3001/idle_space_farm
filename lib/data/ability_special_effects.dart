import '../models/ability_model.dart';
import '../models/enemy_model.dart';
import '../models/girl_farmer_model.dart';
import 'dart:math';

class AbilitySpecialEffects {
  // HP Threshold Abilities
  static bool shouldActivateLastStand(GirlFarmer caster) {
    return caster.hp <= (caster.maxHp * 0.3);
  }

  // Revival Abilities
  static void applyRevival(AbilitiesModel ability, GirlFarmer target) {
    if (target.hp <= 0) {
      target.hp = (target.maxHp * 0.5).round();
      target.statusEffects.removeWhere((effect) =>
          effect.id.contains('debuff') || effect.id.contains('poison'));
      print("${target.name} has been revived!");
    } else {
      target.hp = (target.hp + ability.hpBonus).clamp(0, target.maxHp);
    }
  }

  // Multi-hit Abilities
  static void applyMultiHit(AbilitiesModel ability, dynamic target, int hits) {
    for (int i = 0; i < hits; i++) {
      target.hp = (target.hp - ability.hpBonus).clamp(0, target.maxHp);
      print(
          "${ability.name} hits for ${ability.hpBonus} damage! (${i + 1}/$hits)");
    }
  }

  // Percentage-based Effects
  static int calculatePercentageDamage(double percentage, GirlFarmer caster) {
    return (caster.maxHp * percentage / 100).round();
  }

  // Stealth/Invulnerability
  static void applyStealth(GirlFarmer caster) {
    caster.isUntargetable = true;
    print("${caster.name} vanishes from sight!");
  }

  static void applyInvulnerability(GirlFarmer target, int duration) {
    target.statusEffects.add(StatusEffect(
      id: "invulnerable",
      name: "Invulnerable",
      duration: duration,
      defenseModifier: 999,
    ));
    print("${target.name} becomes invulnerable for $duration turns!");
  }

  // Elemental Switching
  static ElementType determineWeaknessElement(Enemy target) {
    if (target.elementAffinities.isEmpty) return ElementType.none;
    return ElementalSystem.weaknesses[target.elementAffinities.first]?.first ??
        ElementType.none;
  }

  // Special Ability Handlers
  static void handleHeroicSacrifice(
      AbilitiesModel ability, GirlFarmer caster, dynamic target) {
    target.hp = (target.hp - ability.hpBonus).clamp(0, target.maxHp);
    print(
        "${caster.name} deals ${ability.hpBonus} damage with Heroic Sacrifice!");
    caster.hp = 1;
    print("${caster.name}'s HP is reduced to 1!");
  }

  static void handleBloodMoonFrenzy(GirlFarmer caster) {
    caster.attackPoints += 40;
    caster.agilityPoints += 20;
    print("${caster.name} enters a frenzied state!");
  }

  static void handleRagnaroksCall(GirlFarmer caster, List<Enemy> targets) {
    final sacrificeAmount = (caster.hp * 0.5).round();
    caster.hp -= sacrificeAmount;
    final baseDamage = (caster.attackPoints * 3.0).round();

    for (final target in targets) {
      final damage = (baseDamage * (1 - (caster.hp / caster.maxHp))).round();
      target.hp = (target.hp - damage).clamp(0, target.maxHp);
      print("${caster.name} deals $damage damage to ${target.name}!");
    }
    print("${caster.name} sacrificed $sacrificeAmount HP!");
  }
}

class BattleCalculations {
  static int countLivingAllies(
      GirlFarmer caster, List<GirlFarmer> allPartyMembers) {
    // Filter party members by IDs and check if alive
    return caster.partyMemberIds
        .map((id) => allPartyMembers.firstWhere((member) => member.id == id))
        .where((member) => member.hp > 0)
        .length;
  }

  static double calculatePackTacticsBonus(
      GirlFarmer caster, List<GirlFarmer> allPartyMembers) {
    final livingAllies = countLivingAllies(caster, allPartyMembers);
    return min(0.5, livingAllies * 0.1); // 10% per ally, max 50%
  }

  static bool shouldExecuteLowHpBonus(GirlFarmer caster, double threshold) {
    return caster.hp <= (caster.maxHp * threshold);
  }
}
