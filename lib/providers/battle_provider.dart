import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/ability_model.dart';
import '../models/girl_farmer_model.dart';
import '../models/enemy_model.dart';
import '../data/enemy_data.dart';

enum BattleResult { ongoing, win, loss }

class BattleProvider with ChangeNotifier {
  // Constants
  static const int creditsPerEnemy = 50;
  static const double _lowHealthThreshold = 0.3;
  static const double _highHealthThreshold = 0.7;
  static const double _buffPriorityWhenLowHealth = 0.15;
  static const double _healPriorityWhenLowHealth = 0.4;

  // Battle state
  List<GirlFarmer>? _heroes;
  List<Enemy>? _enemies;
  bool _isBattleOver = false;
  String _battleResult = "";
  final List<String> _battleLog = [];
  bool _hasBattleStarted = false;
  bool _isProcessingTurn = false;
  Timer? _battleTimer;
  int _currentRound = 1;

  // Getters
  List<GirlFarmer>? get heroes => _heroes;
  List<Enemy>? get enemies => _enemies;
  bool get isBattleOver => _isBattleOver;
  String get battleResult => _battleResult;
  List<String> get battleLog => _battleLog;
  bool get isProcessingTurn => _isProcessingTurn;
  bool get hasBattleStarted => _hasBattleStarted;
  int get currentRound => _currentRound;

  void startBattle(
    List<GirlFarmer> heroes,
    int dungeonLevel,
    String difficulty, {
    List<Enemy>? predefinedEnemies,
    String region = 'DefaultRegion',
  }) {
    _cleanupPreviousBattle();

    _enemies = predefinedEnemies != null
        ? predefinedEnemies.map((e) => Enemy.freshCopy(e)).toList()
        : generateEnemies(dungeonLevel, difficulty, region: region);

    _heroes = heroes.map((h) => h.copyWithFreshStats()).toList();

    _isBattleOver = false;
    _battleResult = "";
    _battleLog.clear();
    _currentRound = 1;
    _hasBattleStarted = true;

    debugPrint('Battle started with fresh enemies:');
    _enemies?.forEach((e) => debugPrint('${e.name} HP:${e.hp}/${e.maxHp}'));

    _battleLog.add("Battle started!");
    notifyListeners();
  }

  void _cleanupPreviousBattle() {
    _battleTimer?.cancel();
    _heroes?.clear();
    _enemies?.clear();
    _battleLog.clear();
    _heroes = null;
    _enemies = null;
    _currentRound = 1;
    _isBattleOver = false;
    _battleResult = "";
    _isProcessingTurn = false;
    debugPrint('Cleared previous battle data');
  }

  void resetBattle() {
    _cleanupPreviousBattle();
    _hasBattleStarted = false;
    debugPrint("BattleProvider: Battle state fully reset.");
    notifyListeners();
  }

  Future<void> nextTurn() async {
    if (_isBattleOver ||
        _heroes == null ||
        _enemies == null ||
        _isProcessingTurn) {
      debugPrint(
          "Cannot process turn: Battle over, heroes/enemies null, or already processing.");
      return;
    }

    debugPrint("Starting next turn...");
    _isProcessingTurn = true;
    notifyListeners();

    try {
      final allParticipants = <dynamic>[..._heroes!, ..._enemies!];
      allParticipants.sort((a, b) {
        final aAgility =
            a is GirlFarmer ? a.agilityPoints : (a as Enemy).agilityPoints;
        final bAgility =
            b is GirlFarmer ? b.agilityPoints : (b as Enemy).agilityPoints;
        return bAgility.compareTo(aAgility);
      });

      for (final participant in allParticipants) {
        final isDead = participant is GirlFarmer
            ? participant.hp <= 0
            : (participant as Enemy).hp <= 0;

        if (isDead) continue;

        if (participant is GirlFarmer) {
          await _processHeroTurn(participant);
        } else if (participant is Enemy) {
          await _processEnemyTurn(participant as Enemy);
        }

        final battleResult = _checkBattleOver();
        if (battleResult != BattleResult.ongoing) {
          break;
        }

        await Future.delayed(const Duration(milliseconds: 500));
        notifyListeners();
      }

      for (final hero in _heroes!) {
        hero.updateCooldowns();
      }
      for (final enemy in _enemies!) {
        enemy.updateCooldowns();
      }

      _currentRound++;
      _regenerateResources();
      notifyListeners();
    } finally {
      _isProcessingTurn = false;
      notifyListeners();
      debugPrint("Turn completed.");
    }
  }

  void _regenerateResources() {
    // Regenerate MP/SP for heroes
    for (final hero in _heroes!) {
      if (hero.hp > 0) {
        hero.mp = (hero.mp + 2).clamp(0, hero.maxMp).toInt();
        hero.sp = (hero.sp + 5).clamp(0, hero.maxSp).toInt();
        _battleLog.add("${hero.name} recovered 2 MP and 5 SP for new turn!");
      }
    }

    // Regenerate MP/SP for enemies
    for (final enemy in _enemies!) {
      if (enemy.hp > 0) {
        enemy.mp = (enemy.mp + 2).clamp(0, enemy.maxMp).toInt();
        enemy.sp = (enemy.sp + 5).clamp(0, enemy.maxSp).toInt();
        _battleLog.add("${enemy.name} recovered 2 MP and 5 SP for new turn!");
      }
    }

    notifyListeners();
  }

  Future<void> _processHeroTurn(GirlFarmer hero) async {
    final aliveEnemies = _enemies!.where((enemy) => enemy.hp > 0).toList();
    if (aliveEnemies.isEmpty) return;

    final ability = _selectBestAbility(hero, aliveEnemies);
    if (ability == null) {
      // Default basic attack if no ability is available
      final enemy = _selectTarget(hero, aliveEnemies);
      final damage = _calculateDamage(hero, enemy);
      enemy.hp = max<int>(0, enemy.hp - damage);
      _battleLog.add("${hero.name} attacked ${enemy.name} for $damage damage!");
      if (enemy.hp <= 0) {
        _battleLog.add("${enemy.name} was defeated!");
      }
      return;
    }

    // Check resource costs
    if (hero.mp < ability.mpCost || hero.sp < ability.spCost) {
      _battleLog.add(
          "${hero.name} does not have enough MP/SP to use ${ability.name}.");
      return;
    }

    // Pay costs and set cooldown
    hero.mp -= ability.mpCost;
    hero.sp -= ability.spCost;
    hero.currentCooldowns[ability.abilitiesID] = ability.cooldown;

    // Apply the ability effects
    _applyAbilityEffects(hero, ability, aliveEnemies);

    // Log ability usage
    _battleLog.add("${hero.name} used ${ability.name}!");
  }

  AbilitiesModel? _selectBestAbility(
      GirlFarmer hero, List<Enemy> aliveEnemies) {
    final availableAbilities = hero.abilities.where((ability) {
      return (hero.currentCooldowns[ability.abilitiesID] ?? 0) == 0 &&
          hero.mp >= ability.mpCost &&
          hero.sp >= ability.spCost;
    }).toList();

    if (availableAbilities.isEmpty) return null;

    // Calculate health status (0.0 to 1.0)
    final healthRatio = hero.hp / hero.maxHp;
    final isLowHealth = healthRatio < _lowHealthThreshold;
    final isHighHealth = healthRatio > _highHealthThreshold;

    // Score each ability based on current situation
    final scoredAbilities = availableAbilities.map((ability) {
      double score = 0.0;
      final randomFactor = Random().nextDouble() * 0.2; // Add some randomness

      switch (ability.type) {
        case AbilityType.attack:
          // Prioritize attack when not in low health
          score = isLowHealth ? 0.3 : 0.8;
          // Increase score for AoE abilities when multiple enemies
          if (ability.targetType == TargetType.all && aliveEnemies.length > 1) {
            score *= 1.5;
          }
          break;

        case AbilityType.heal:
          // Prioritize heal more when health is low
          score = isLowHealth ? _healPriorityWhenLowHealth : 0.1;
          // Increase score if healing would be significant
          if ((hero.maxHp - hero.hp) > ability.hpBonus * 2) {
            score *= 1.5;
          }
          break;

        case AbilityType.buff:
          // Buffs are more valuable when health is medium to high
          score = isLowHealth ? _buffPriorityWhenLowHealth : 0.6;
          // Increase score if buffs would help survive or deal more damage
          if (aliveEnemies.length > 1 || isHighHealth) {
            score *= 1.2;
          }
          break;

        case AbilityType.debuff:
          // Debuffs are generally useful but more so against strong enemies
          score = 0.5;
          if (aliveEnemies.any((e) => e.attackPoints > hero.defensePoints)) {
            score *= 1.3;
          }
          break;
      }

      // Adjust for SP/MP efficiency (lower cost abilities get a slight boost)
      final costEfficiency =
          1.0 - (ability.mpCost + ability.spCost) / (hero.maxMp + hero.maxSp);
      score *= (0.8 + costEfficiency * 0.2);

      return _ScoredAbility(ability, score + randomFactor);
    }).toList();

    // Sort by score and pick the best one
    scoredAbilities.sort((a, b) => b.score.compareTo(a.score));
    return scoredAbilities.first.ability;
  }

  Enemy _selectTarget(GirlFarmer hero, List<Enemy> aliveEnemies) {
    // Simple target selection - prioritize low health enemies
    return aliveEnemies.reduce((a, b) => a.hp < b.hp ? a : b);
  }

  void _applyAbilityEffects(
      GirlFarmer hero, AbilitiesModel ability, List<Enemy> enemies) {
    final targets = _getAbilityTargets(hero, ability, enemies);

    for (final target in targets) {
      if (target.hp <= 0) continue;

      switch (ability.type) {
        case AbilityType.attack:
          if (ability.affectsEnemies && target is Enemy) {
            final damage = _calculateAbilityDamage(hero, ability, target);
            target.hp = max<int>(0, target.hp - damage);
            _battleLog.add(
                "${hero.name} dealt $damage damage to ${target.name} with ${ability.name}!");

            if (target.hp <= 0) {
              _battleLog.add("${target.name} was defeated!");
            }

            _checkCriticalEffect(hero, ability, target, isHealing: false);
          }
          break;

        case AbilityType.heal:
          if (!ability.affectsEnemies && target is GirlFarmer) {
            final healAmount = _calculateHealAmount(hero, ability, target);
            target.hp = min(target.maxHp, target.hp + healAmount);
            _battleLog.add(
                "${hero.name} healed ${target == hero ? 'themself' : target.name} for $healAmount HP with ${ability.name}!");

            _checkCriticalEffect(hero, ability, target, isHealing: true);
          }
          break;

        case AbilityType.buff:
          if (!ability.affectsEnemies && target is GirlFarmer) {
            target.attackPoints += ability.attackBonus;
            target.defensePoints += ability.defenseBonus;
            target.agilityPoints += ability.agilityBonus;
            _battleLog.add(
                "${target == hero ? 'Their' : target.name + "'s"} stats increased by "
                "${ability.attackBonus} ATK, ${ability.defenseBonus} DEF, "
                "and ${ability.agilityBonus} AGI from ${ability.name}!");
          }
          break;

        case AbilityType.debuff:
          if (ability.affectsEnemies && target is Enemy) {
            target.attackPoints =
                max(0, target.attackPoints - ability.attackBonus);
            target.defensePoints =
                max(0, target.defensePoints - ability.defenseBonus);
            target.agilityPoints =
                max(0, target.agilityPoints - ability.agilityBonus);
            _battleLog.add("${target.name}'s stats decreased by "
                "${ability.attackBonus} ATK, ${ability.defenseBonus} DEF, "
                "and ${ability.agilityBonus} AGI from ${ability.name}!");
          }
          break;
      }
    }
  }

  int _calculateAbilityDamage(
      GirlFarmer hero, AbilitiesModel ability, Enemy target) {
    final baseDamage = ability.hpBonus; // Using hpBonus as base damage
    final defenseReduction = (target.defensePoints * 0.5)
        .round(); // Defense reduces damage by 50% of its value
    return max(0, baseDamage - defenseReduction);
  }

  int _calculateHealAmount(
      GirlFarmer hero, AbilitiesModel ability, GirlFarmer target) {
    return ability.hpBonus; // Could add modifiers based on stats
  }

  List<dynamic> _getAbilityTargets(
      GirlFarmer hero, AbilitiesModel ability, List<Enemy> enemies) {
    if (ability.affectsEnemies) {
      if (ability.targetType == TargetType.all) {
        return enemies.where((e) => e.hp > 0).toList();
      } else {
        return [_selectTarget(hero, enemies)];
      }
    } else {
      if (ability.targetType == TargetType.all) {
        return _heroes!.where((h) => h.hp > 0).toList();
      } else {
        return [hero];
      }
    }
  }

  void _checkCriticalEffect(
      GirlFarmer hero, AbilitiesModel ability, dynamic target,
      {bool isHealing = false}) {
    if (ability.criticalPoint <= 0) return;

    final random = Random();
    if (random.nextInt(100) < ability.criticalPoint) {
      final criticalMultiplier = isHealing ? 1.5 : 2.0;
      final baseEffect = isHealing
          ? ability.hpBonus
          : _calculateAbilityDamage(hero, ability, target);
      final criticalEffect = (baseEffect * criticalMultiplier).round();

      if (isHealing) {
        target.hp = min<int>(target.maxHp, target.hp + criticalEffect);
        _battleLog
            .add("Critical heal! ${target == hero ? 'They' : target.name} "
                "recovered an extra $criticalEffect HP!");
      } else {
        target.hp = max<int>(0, target.hp - criticalEffect);
        _battleLog.add(
            "Critical hit! ${target.name} took $criticalEffect extra damage!");

        if (target.hp <= 0) {
          _battleLog.add("${target.name} was defeated!");
        }
      }
    }
  }

  Future<void> _processEnemyTurn(Enemy enemy) async {
    final aliveHeroes = _heroes!.where((hero) => hero.hp > 0).toList();
    if (aliveHeroes.isEmpty) return;

    final ability = _selectBestEnemyAbility(enemy, aliveHeroes);
    if (ability == null) {
      // Default basic attack
      final hero = _selectEnemyTarget(enemy, aliveHeroes);
      final damage = _calculateDamage(enemy, hero);
      hero.hp = max<int>(0, hero.hp - damage);
      _battleLog.add("${enemy.name} attacked ${hero.name} for $damage damage!");
      if (hero.hp <= 0) {
        _battleLog.add("${hero.name} was defeated!");
      }
      return;
    }

    // Check resource costs
    if (enemy.mp < ability.mpCost || enemy.sp < ability.spCost) {
      return;
    }

    // Pay costs and set cooldown
    enemy.mp -= ability.mpCost;
    enemy.sp -= ability.spCost;
    enemy.currentCooldowns[ability.abilitiesID] = ability.cooldown;

    // Apply the ability effects
    _applyEnemyAbilityEffects(enemy, ability, aliveHeroes);

    // Log ability usage
    _battleLog.add("${enemy.name} used ${ability.name}!");
  }

  AbilitiesModel? _selectBestEnemyAbility(
      Enemy enemy, List<GirlFarmer> aliveHeroes) {
    final availableAbilities = enemy.abilities.where((ability) {
      return (enemy.currentCooldowns[ability.abilitiesID] ?? 0) == 0 &&
          enemy.mp >= ability.mpCost &&
          enemy.sp >= ability.spCost;
    }).toList();

    if (availableAbilities.isEmpty) return null;

    // Calculate health status (0.0 to 1.0)
    final healthRatio = enemy.hp / enemy.maxHp;
    final isLowHealth = healthRatio < _lowHealthThreshold;
    final isHighHealth = healthRatio > _highHealthThreshold;

    // Enemy AI behavior based on health and situation
    final scoredAbilities = availableAbilities.map((ability) {
      double score = 0.0;
      final randomFactor = Random().nextDouble() * 0.2;

      switch (ability.type) {
        case AbilityType.attack:
          // Enemies prefer to attack when not in low health
          score = isLowHealth ? 0.4 : 0.9;
          // Prefer AoE when multiple heroes
          if (ability.targetType == TargetType.all && aliveHeroes.length > 1) {
            score *= 1.5;
          }
          break;

        case AbilityType.heal:
          // Enemies heal when low health
          score = isLowHealth ? 0.7 : 0.1;
          // More likely to heal if heal would be significant
          if ((enemy.maxHp - enemy.hp) > ability.hpBonus * 2) {
            score *= 1.5;
          }
          break;

        case AbilityType.buff:
          // Buff when health is medium to high
          score = isLowHealth ? 0.2 : 0.6;
          // More likely to buff if facing multiple heroes
          if (aliveHeroes.length > 1) {
            score *= 1.3;
          }
          break;

        case AbilityType.debuff:
          // Debuff priority increases with number of heroes
          score = 0.5 + (aliveHeroes.length * 0.1);
          break;
      }

      // Adjust for SP/MP efficiency
      final costEfficiency =
          1.0 - (ability.mpCost + ability.spCost) / (enemy.maxMp + enemy.maxSp);
      score *= (0.8 + costEfficiency * 0.2);

      return _ScoredAbility(ability, score + randomFactor);
    }).toList();

    // Sort by score and pick the best one
    scoredAbilities.sort((a, b) => b.score.compareTo(a.score));
    return scoredAbilities.first.ability;
  }

  GirlFarmer _selectEnemyTarget(Enemy enemy, List<GirlFarmer> aliveHeroes) {
    // Enemy AI target selection - prioritize low health heroes
    return aliveHeroes.reduce((a, b) => a.hp < b.hp ? a : b);
  }

  void _applyEnemyAbilityEffects(
      Enemy enemy, AbilitiesModel ability, List<GirlFarmer> heroes) {
    final targets = _getEnemyAbilityTargets(enemy, ability, heroes);

    for (final target in targets) {
      if (target.hp <= 0) continue;

      switch (ability.type) {
        case AbilityType.attack:
          if (ability.affectsEnemies && target is GirlFarmer) {
            final damage = _calculateEnemyAbilityDamage(enemy, ability, target);
            target.hp = max<int>(0, target.hp - damage);
            _battleLog.add(
                "${enemy.name} dealt $damage damage to ${target.name} with ${ability.name}!");

            if (target.hp <= 0) {
              _battleLog.add("${target.name} was defeated!");
            }

            _checkEnemyCriticalEffect(enemy, ability, target, isHealing: false);
          }
          break;

        case AbilityType.heal:
          if (!ability.affectsEnemies && target is Enemy) {
            final healAmount = ability.hpBonus;
            target.hp = min(target.maxHp, target.hp + healAmount);
            _battleLog.add(
                "${enemy.name} healed ${target == enemy ? 'itself' : target.name} for $healAmount HP with ${ability.name}!");

            _checkEnemyCriticalEffect(enemy, ability, target, isHealing: true);
          }
          break;

        case AbilityType.buff:
          if (!ability.affectsEnemies && target is Enemy) {
            target.attackPoints += ability.attackBonus;
            target.defensePoints += ability.defenseBonus;
            target.agilityPoints += ability.agilityBonus;
            _battleLog.add(
                "${target == enemy ? 'Its' : target.name + "'s"} stats increased by "
                "${ability.attackBonus} ATK, ${ability.defenseBonus} DEF, "
                "and ${ability.agilityBonus} AGI from ${ability.name}!");
          }
          break;

        case AbilityType.debuff:
          if (ability.affectsEnemies && target is GirlFarmer) {
            target.attackPoints =
                max(0, target.attackPoints - ability.attackBonus);
            target.defensePoints =
                max(0, target.defensePoints - ability.defenseBonus);
            target.agilityPoints =
                max(0, target.agilityPoints - ability.agilityBonus);
            _battleLog.add("${target.name}'s stats decreased by "
                "${ability.attackBonus} ATK, ${ability.defenseBonus} DEF, "
                "and ${ability.agilityBonus} AGI from ${ability.name}!");
          }
          break;
      }
    }
  }

  int _calculateEnemyAbilityDamage(
      Enemy enemy, AbilitiesModel ability, GirlFarmer target) {
    final baseDamage = ability.hpBonus;
    final defenseReduction = (target.defensePoints * 0.5).round();
    return max(0, baseDamage - defenseReduction);
  }

  void _checkEnemyCriticalEffect(
      Enemy enemy, AbilitiesModel ability, dynamic target,
      {bool isHealing = false}) {
    if (ability.criticalPoint <= 0) return;

    final random = Random();
    if (random.nextInt(100) < ability.criticalPoint) {
      final criticalMultiplier = isHealing ? 1.5 : 2.0;
      final baseEffect = isHealing
          ? ability.hpBonus
          : _calculateEnemyAbilityDamage(enemy, ability, target);
      final criticalEffect = (baseEffect * criticalMultiplier).round();

      if (isHealing) {
        target.hp = min<int>(target.maxHp, target.hp + criticalEffect);
        _battleLog.add("Critical heal! ${target == enemy ? 'It' : target.name} "
            "recovered an extra $criticalEffect HP!");
      } else {
        target.hp = max<int>(0, target.hp - criticalEffect);
        _battleLog.add(
            "Critical hit! ${target.name} took $criticalEffect extra damage!");

        if (target.hp <= 0) {
          _battleLog.add("${target.name} was defeated!");
        }
      }
    }
  }

  List<dynamic> _getEnemyAbilityTargets(
      Enemy enemy, AbilitiesModel ability, List<GirlFarmer> heroes) {
    if (ability.affectsEnemies) {
      if (ability.targetType == TargetType.all) {
        return heroes.where((h) => h.hp > 0).toList();
      } else {
        return [_selectEnemyTarget(enemy, heroes)];
      }
    } else {
      if (ability.targetType == TargetType.all) {
        return _enemies!.where((e) => e.hp > 0).toList();
      } else {
        return [enemy];
      }
    }
  }

  int _calculateDamage(dynamic attacker, dynamic defender) {
    final attackerAttack = attacker is GirlFarmer
        ? attacker.attackPoints
        : (attacker as Enemy).attackPoints;
    final defenderDefense = defender is GirlFarmer
        ? defender.defensePoints
        : (defender as Enemy).defensePoints;
    final baseDamage =
        max<int>(1, (attackerAttack * 0.75 - defenderDefense * 0.5).round());

    final attackerAgility = attacker is GirlFarmer
        ? attacker.agilityPoints
        : (attacker as Enemy).agilityPoints;
    final defenderAgility = defender is GirlFarmer
        ? defender.agilityPoints
        : (defender as Enemy).agilityPoints;
    final avoidChance =
        (defenderAgility / (defenderAgility + attackerAgility)) * 0.5;

    if (Random().nextDouble() < avoidChance) {
      _battleLog.add("${defender.name} avoided the attack!");
      return 0;
    }

    final criticalChance = attacker is GirlFarmer
        ? attacker.criticalPoint
        : (attacker as Enemy).criticalPoint;
    final random = Random();

    if (random.nextInt(100) < criticalChance) {
      final criticalMultiplier = 1.5 + (attackerAgility / 100);
      final criticalDamage = (baseDamage * criticalMultiplier).toInt();
      _battleLog.add(
          "${attacker.name} landed a critical hit for $criticalDamage damage!");
      return criticalDamage;
    }

    return baseDamage;
  }

  BattleResult _checkBattleOver() {
    if (_heroes!.every((hero) => hero.hp <= 0)) {
      debugPrint("Battle over: All heroes defeated");
      _isBattleOver = true;
      _battleResult = "Loss";
      _battleLog.add("Battle over! Player loses!");
      notifyListeners();
      return BattleResult.loss;
    } else if (_enemies!.every((enemy) => enemy.hp <= 0)) {
      debugPrint("Battle over: All enemies defeated");
      _isBattleOver = true;
      _battleResult = "Win";
      _battleLog.add("Battle over! Player wins!");
      notifyListeners();
      return BattleResult.win;
    }
    return BattleResult.ongoing;
  }

  void autoBattle(BuildContext context) {
    if (_isBattleOver ||
        _heroes == null ||
        _enemies == null ||
        _isProcessingTurn) {
      debugPrint("Cannot start auto-battle: Invalid state");
      return;
    }

    debugPrint("Starting auto-battle...");
    _battleTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_isBattleOver) {
        timer.cancel();
        debugPrint("Auto-battle stopped: Battle is over.");
        return;
      }

      await nextTurn();

      if (_isBattleOver) {
        timer.cancel();
        _showBattleResultDialog(context);
      }
    });
  }

  void stopAutoBattle() {
    _battleTimer?.cancel();
  }

  void processRewards() {
    if (_battleResult == "Win") {
      final creditsEarned = _enemies!.length * creditsPerEnemy;
      _battleLog.add("Player wins! Earned $creditsEarned credits.");
    } else {
      _battleLog.add("Player loses. Better luck next time!");
    }
  }

  void _showBattleResultDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(_battleResult == "Win" ? "Victory!" : "Defeat!"),
          content: Text(_battleResult == "Win"
              ? "Congratulations! You won the battle!"
              : "Oh no! You lost the battle."),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                resetBattle();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      );
    });
  }
}

class _ScoredAbility {
  final AbilitiesModel ability;
  final double score;

  _ScoredAbility(this.ability, this.score);
}
