import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../data/enemy_data.dart';
import '../models/ability_model.dart';
import '../models/enemy_model.dart';
import '../models/girl_farmer_model.dart';

enum BattleResult { ongoing, win, loss }

class BattleProvider with ChangeNotifier {
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

    _battleLog.add("=== BATTLE STARTED ===");
    _logInitialStats();
    notifyListeners();
  }

  void _logInitialStats() {
    _battleLog.add("\nHEROES:");
    _heroes?.forEach((hero) {
      _battleLog.add(
          "${hero.name} - HP: ${hero.hp}/${hero.maxHp} | MP: ${hero.mp}/${hero.maxMp} | SP: ${hero.sp}/${hero.maxSp}");
    });

    _battleLog.add("\nENEMIES:");
    _enemies?.forEach((enemy) {
      _battleLog.add(
          "${enemy.name} - HP: ${enemy.hp}/${enemy.maxHp} | MP: ${enemy.mp}/${enemy.maxMp} | SP: ${enemy.sp}/${enemy.maxSp}");
    });
  }

  Future<void> nextTurn() async {
    if (_isBattleOver ||
        _heroes == null ||
        _enemies == null ||
        _isProcessingTurn) {
      return;
    }

    _isProcessingTurn = true;
    notifyListeners();

    try {
      // 1. Process status effects for all participants
      _processAllStatusEffects();

      // 2. Determine turn order with agility and status modifiers
      final participants = _determineTurnOrder();

      // 3. Execute turns
      for (final participant in participants) {
        if (_isBattleOver) break;
        await _executeParticipantTurn(participant);
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // 4. End of round cleanup
      if (!_isBattleOver) {
        _currentRound++;
        _regenerateResources();
        _battleLog.add("\n=== ROUND $_currentRound ===");
      }
    } finally {
      _isProcessingTurn = false;
      notifyListeners();
    }
  }

  void _processAllStatusEffects() {
    final allParticipants = [...?_heroes, ...?_enemies];
    for (final participant in allParticipants) {
      if (participant is GirlFarmer) {
        participant.processStatusEffects();
      } else if (participant is Enemy) {
        participant.processStatusEffects();
      }
    }
  }

  List<dynamic> _determineTurnOrder() {
    final allParticipants = [...?_heroes, ...?_enemies]
      ..removeWhere((p) => switch (p) {
            GirlFarmer(:var hp, :var skipNextTurn) ||
            Enemy(:var hp, :var skipNextTurn) =>
              hp <= 0 || skipNextTurn,
            _ => true,
          });

    // Sort by agility with status effect modifiers
    allParticipants.sort((a, b) {
      final aAgility = _getEffectiveAgility(a);
      final bAgility = _getEffectiveAgility(b);
      return bAgility.compareTo(aAgility); // Descending order
    });

    return allParticipants;
  }

  int _getEffectiveAgility(dynamic participant) {
    int agility = 0;

    if (participant is GirlFarmer) {
      agility = participant.agilityPoints;
    } else if (participant is Enemy) {
      agility = participant.agilityPoints;
    }

    if (participant is GirlFarmer || participant is Enemy) {
      for (final effect in participant.statusEffects) {
        agility += effect.agilityModifier is int
            ? effect.agilityModifier as int
            : (effect.agilityModifier as double).round();
      }
    }

    return agility + Random().nextInt(5);
  }

  Future<void> _executeParticipantTurn(dynamic participant) async {
    if (participant is GirlFarmer) {
      await _processHeroTurn(participant);
    } else if (participant is Enemy) {
      await _processEnemyTurn(participant);
    }

    _checkBattleOver();
  }

  Future<void> _processHeroTurn(GirlFarmer hero) async {
    if (hero.mindControlled) {
      await _processMindControlledHero(hero);
      return;
    }

    final aliveEnemies = _enemies!.where((e) => e.hp > 0).toList();
    if (aliveEnemies.isEmpty) return;

    final ability = _selectBestHeroAbility(hero, aliveEnemies);
    if (ability != null) {
      _executeHeroAbility(hero, ability, aliveEnemies);
    } else {
      _executeBasicAttack(hero, aliveEnemies);
    }
  }

  Future<void> _processMindControlledHero(GirlFarmer hero) async {
    final aliveAllies =
        _heroes!.where((h) => h.hp > 0 && h.id != hero.id).toList();
    if (aliveAllies.isEmpty) return;

    final target = aliveAllies[Random().nextInt(aliveAllies.length)];
    final damage = _calculateDamage(hero, target);
    target.hp = max(0, target.hp - damage);

    _battleLog.add(
        "${hero.name} (mind controlled) attacks ${target.name} for $damage damage!");
    if (target.hp <= 0) {
      _battleLog.add("${target.name} was defeated!");
    }
  }

  AbilitiesModel? _selectBestHeroAbility(
      GirlFarmer hero, List<Enemy> aliveEnemies) {
    final availableAbilities = hero.abilities.where((ability) {
      return (hero.currentCooldowns[ability.abilitiesID] ?? 0) == 0 &&
          hero.mp >= ability.mpCost &&
          hero.sp >= ability.spCost;
    }).toList();

    if (availableAbilities.isEmpty) return null;

    return availableAbilities
        .map((ability) => _scoreAbility(ability, hero, aliveEnemies))
        .reduce((a, b) => a.score > b.score ? a : b)
        .ability;
  }

  _ScoredAbility _scoreAbility(
      AbilitiesModel ability, GirlFarmer hero, List<Enemy> enemies) {
    double score = 0.0;
    final healthRatio = hero.hp / hero.maxHp;
    final isLowHealth = healthRatio < 0.3;
    final randomFactor = Random().nextDouble() * 0.2;

    switch (ability.type) {
      case AbilityType.attack:
        score = isLowHealth ? 0.4 : 0.8;
        if (ability.targetType == TargetType.all && enemies.length > 1) {
          score *= 1.5;
        }
        score *= _calculateElementalScore(ability, enemies);
        break;
      case AbilityType.heal:
        score = isLowHealth ? 0.7 : 0.2;
        if ((hero.maxHp - hero.hp) > ability.hpBonus * 2) {
          score *= 1.5;
        }
        break;
      case AbilityType.buff:
        score = isLowHealth ? 0.3 : 0.6;
        if (enemies.length > 1) {
          score *= 1.2;
        }
        break;
      case AbilityType.debuff:
        score = 0.5 + (enemies.length * 0.1);
        break;
      case AbilityType.control:
        score = 0.4;
        break;
    }

    final costEfficiency =
        1.0 - (ability.mpCost + ability.spCost) / (hero.maxMp + hero.maxSp);
    score *= (0.8 + costEfficiency * 0.2);

    return _ScoredAbility(ability, score + randomFactor);
  }

  double _calculateElementalScore(AbilitiesModel ability, List<Enemy> enemies) {
    if (ability.elementType == ElementType.none) return 1.0;

    double maxMultiplier = 1.0;
    for (final enemy in enemies) {
      final multiplier = ElementalSystem.getElementMultiplier(
        ability.elementType,
        enemy.elementAffinities,
      );
      if (multiplier > maxMultiplier) {
        maxMultiplier = multiplier;
      }
    }
    return maxMultiplier > 1.0 ? 1.2 : 1.0;
  }

  void _executeHeroAbility(
      GirlFarmer hero, AbilitiesModel ability, List<Enemy> enemies) {
    hero.mp -= ability.mpCost;
    hero.sp -= ability.spCost;

    // Use the existing _updateCooldown method
    hero.setCooldown(ability.abilitiesID, ability.cooldown);

    final targets = _getAbilityTargets(hero, ability, enemies);
    for (final target in targets) {
      if (target.hp <= 0) continue;

      ability.applyEffect(target, caster: hero);
      _logAbilityEffect(hero, ability, target);

      if (target.hp <= 0) {
        _battleLog.add("${target.name} was defeated!");
      }
    }

    if (ability.healsCaster) {
      _battleLog.add("${hero.name} healed ${ability.healCasterAmount} HP!");
    }
  }

  List<dynamic> _getAbilityTargets(
      GirlFarmer hero, AbilitiesModel ability, List<Enemy> enemies) {
    if (ability.affectsEnemies) {
      return ability.targetType == TargetType.all
          ? enemies.where((e) => e.hp > 0).toList()
          : [_selectTarget(hero, enemies)];
    } else {
      return ability.targetType == TargetType.all
          ? _heroes!.where((h) => h.hp > 0).toList()
          : [hero];
    }
  }

  void _logAbilityEffect(
      GirlFarmer hero, AbilitiesModel ability, dynamic target) {
    final elementInfo = ability.elementType != ElementType.none
        ? " (${ability.elementType})"
        : "";
    final targetName = target == hero ? 'themself' : target.name;

    switch (ability.type) {
      case AbilityType.attack:
        _battleLog.add(
            "${hero.name} used ${ability.name}$elementInfo on ${target.name}!");
        break;
      case AbilityType.heal:
        _battleLog.add("${hero.name} healed $targetName with ${ability.name}!");
        break;
      case AbilityType.buff:
        _battleLog.add("${hero.name} buffed $targetName with ${ability.name}!");
        break;
      case AbilityType.debuff:
        _battleLog
            .add("${hero.name} debuffed ${target.name} with ${ability.name}!");
        break;
      case AbilityType.control:
        _battleLog.add("${hero.name} used ${ability.name} on ${target.name}!");
        break;
    }
  }

  void _executeBasicAttack(GirlFarmer hero, List<Enemy> enemies) {
    final target = _selectTarget(hero, enemies);
    final damage = _calculateDamage(hero, target);
    target.hp = max(0, target.hp - damage);

    _battleLog.add("${hero.name} attacks ${target.name} for $damage damage!");
    if (target.hp <= 0) {
      _battleLog.add("${target.name} was defeated!");
    }
  }

  Enemy _selectTarget(GirlFarmer hero, List<Enemy> enemies) {
    try {
      return enemies.firstWhere((e) => e.forcedTarget == hero);
    } catch (_) {
      return enemies.reduce((a, b) => a.hp < b.hp ? a : b);
    }
  }

  Future<void> _processEnemyTurn(Enemy enemy) async {
    enemy.processControlEffects(_heroes!.where((h) => h.hp > 0).toList());
    if (enemy.skipNextTurn || enemy.mindControlled) return;

    final aliveHeroes = _heroes!.where((h) => h.hp > 0).toList();
    if (aliveHeroes.isEmpty) return;

    final ability = _selectBestEnemyAbility(enemy, aliveHeroes);
    if (ability != null) {
      _executeEnemyAbility(enemy, ability, aliveHeroes);
    } else {
      _executeBasicEnemyAttack(enemy, aliveHeroes);
    }
  }

  AbilitiesModel? _selectBestEnemyAbility(
      Enemy enemy, List<GirlFarmer> heroes) {
    final availableAbilities = enemy.abilities.where((ability) {
      return (enemy.currentCooldowns[ability.abilitiesID] ?? 0) == 0 &&
          enemy.mp >= ability.mpCost &&
          enemy.sp >= ability.spCost;
    }).toList();

    if (availableAbilities.isEmpty) return null;

    return availableAbilities
        .map((ability) => _scoreEnemyAbility(ability, enemy, heroes))
        .reduce((a, b) => a.score > b.score ? a : b)
        .ability;
  }

  _ScoredAbility _scoreEnemyAbility(
      AbilitiesModel ability, Enemy enemy, List<GirlFarmer> heroes) {
    double score = 0.0;
    final healthRatio = enemy.hp / enemy.maxHp;
    final isLowHealth = healthRatio < 0.3;
    final randomFactor = Random().nextDouble() * 0.2;

    switch (ability.type) {
      case AbilityType.attack:
        score = isLowHealth ? 0.4 : 0.8;
        if (ability.targetType == TargetType.all && heroes.length > 1) {
          score *= 1.5;
        }
        break;
      case AbilityType.heal:
        score = isLowHealth ? 0.7 : 0.2;
        if ((enemy.maxHp - enemy.hp) > ability.hpBonus * 2) {
          score *= 1.5;
        }
        break;
      case AbilityType.buff:
        score = isLowHealth ? 0.3 : 0.6;
        if (heroes.length > 1) {
          score *= 1.2;
        }
        break;
      case AbilityType.debuff:
        score = 0.5 + (heroes.length * 0.1);
        break;
      case AbilityType.control:
        score = 0.4;
        break;
    }

    final costEfficiency =
        1.0 - (ability.mpCost + ability.spCost) / (enemy.maxMp + enemy.maxSp);
    score *= (0.8 + costEfficiency * 0.2);

    return _ScoredAbility(ability, score + randomFactor);
  }

  void _executeEnemyAbility(
      Enemy enemy, AbilitiesModel ability, List<GirlFarmer> heroes) {
    enemy.mp -= ability.mpCost;
    enemy.sp -= ability.spCost;

    // Safe cooldown update
    final cooldowns = Map<String, int>.from(enemy.currentCooldowns);
    cooldowns[ability.abilitiesID] = ability.cooldown;
    enemy.currentCooldowns = cooldowns;

    final targets = _getEnemyAbilityTargets(enemy, ability, heroes);
    for (final target in targets) {
      if (target.hp <= 0) continue;

      ability.applyEffect(target, caster: enemy);
      _logEnemyAbilityEffect(enemy, ability, target);

      if (target.hp <= 0) {
        _battleLog.add("${target.name} was defeated!");
      }
    }
  }

  List<dynamic> _getEnemyAbilityTargets(
      Enemy enemy, AbilitiesModel ability, List<GirlFarmer> heroes) {
    if (ability.affectsEnemies) {
      return ability.targetType == TargetType.all
          ? heroes.where((h) => h.hp > 0).toList()
          : [_selectEnemyTarget(enemy, heroes)];
    } else {
      return ability.targetType == TargetType.all
          ? _enemies!.where((e) => e.hp > 0).toList()
          : [enemy];
    }
  }

  void _logEnemyAbilityEffect(
      Enemy enemy, AbilitiesModel ability, dynamic target) {
    final elementInfo = ability.elementType != ElementType.none
        ? " (${ability.elementType})"
        : "";
    final targetName = target == enemy ? 'itself' : target.name;

    switch (ability.type) {
      case AbilityType.attack:
        _battleLog.add(
            "${enemy.name} used ${ability.name}$elementInfo on ${target.name}!");
        break;
      case AbilityType.heal:
        _battleLog
            .add("${enemy.name} healed $targetName with ${ability.name}!");
        break;
      case AbilityType.buff:
        _battleLog
            .add("${enemy.name} buffed $targetName with ${ability.name}!");
        break;
      case AbilityType.debuff:
        _battleLog
            .add("${enemy.name} debuffed ${target.name} with ${ability.name}!");
        break;
      case AbilityType.control:
        _battleLog.add("${enemy.name} used ${ability.name} on ${target.name}!");
        break;
    }
  }

  void _executeBasicEnemyAttack(Enemy enemy, List<GirlFarmer> heroes) {
    final target = _selectEnemyTarget(enemy, heroes);
    final damage = _calculateDamage(enemy, target);
    target.hp = max(0, target.hp - damage);

    _battleLog.add("${enemy.name} attacks ${target.name} for $damage damage!");
    if (target.hp <= 0) {
      _battleLog.add("${target.name} was defeated!");
    }
  }

  GirlFarmer _selectEnemyTarget(Enemy enemy, List<GirlFarmer> heroes) {
    return heroes.reduce((a, b) => a.hp < b.hp ? a : b);
  }

  int _calculateDamage(dynamic attacker, dynamic defender) {
    int attack = 0;
    int defense = 0;

    if (attacker is GirlFarmer) {
      attack = attacker.attackPoints;
    } else if (attacker is Enemy) {
      attack = attacker.attackPoints;
    }

    if (defender is GirlFarmer) {
      defense = defender.defensePoints;
    } else if (defender is Enemy) {
      defense = defender.defensePoints;
    }

    var damage = max(1, (attack * 0.75 - defense * 0.5).round());

    final critChance = attacker is GirlFarmer
        ? attacker.criticalPoint
        : (attacker as Enemy).criticalPoint;
    if (Random().nextInt(100) < critChance) {
      damage = (damage * 1.5).round();
      _battleLog.add("Critical hit!");
    }

    return damage;
  }

  void _regenerateResources() {
    for (final hero in _heroes!) {
      if (hero.hp > 0) {
        hero.mp = min(hero.maxMp, hero.mp + 2);
        hero.sp = min(hero.maxSp, hero.sp + 5);
      }
    }

    for (final enemy in _enemies!) {
      if (enemy.hp > 0) {
        enemy.mp = min(enemy.maxMp, enemy.mp + 2);
        enemy.sp = min(enemy.maxSp, enemy.sp + 5);
      }
    }
  }

  BattleResult _checkBattleOver() {
    if (_heroes!.every((hero) => hero.hp <= 0)) {
      _endBattle("Defeat");
      return BattleResult.loss;
    } else if (_enemies!.every((enemy) => enemy.hp <= 0)) {
      _endBattle("Victory");
      return BattleResult.win;
    }
    return BattleResult.ongoing;
  }

  void _endBattle(String result) {
    _isBattleOver = true;
    _battleResult = result;
    _battleLog.add("\n=== BATTLE ENDED: $result ===");
    _processRewards();
    notifyListeners();
  }

  void _processRewards() {
    if (_battleResult == "Victory") {
      final credits = _enemies!.length * 50;
      _battleLog.add("Earned $credits credits!");
    }
  }

  void _cleanupPreviousBattle() {
    _battleTimer?.cancel();

    // Create new modifiable lists instead of modifying existing ones
    _heroes = _heroes?.map((h) {
      final newHero = h.copyWithFreshStats(); // This should create a fresh copy
      return newHero;
    }).toList();

    _enemies = _enemies?.map((e) => Enemy.freshCopy(e)).toList();

    _battleLog.clear(); // This should be fine as it's your own list
    _currentRound = 1;
    _isBattleOver = false;
    _battleResult = "";
    _isProcessingTurn = false;
  }

  void resetBattle() {
    _cleanupPreviousBattle();
    _hasBattleStarted = false;
    notifyListeners();
  }

  void autoBattle(BuildContext context) {
    _battleTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_isBattleOver) {
        timer.cancel();
        return;
      }

      await nextTurn();
    });
  }

  void stopAutoBattle() {
    _battleTimer?.cancel();
  }

  @override
  void dispose() {
    _battleTimer?.cancel();
    super.dispose();
  }
}

class _ScoredAbility {
  final AbilitiesModel ability;
  final double score;

  _ScoredAbility(this.ability, this.score);
}
