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
        for (final ability in hero.abilities) {
          ability.updateCooldown();
        }
      }

      _currentRound++;
      notifyListeners();
    } finally {
      _isProcessingTurn = false;
      notifyListeners();
      debugPrint("Turn completed.");
    }
  }

  Future<void> _processHeroTurn(GirlFarmer hero) async {
    final aliveEnemies = _enemies!.where((enemy) => enemy.hp > 0).toList();
    if (aliveEnemies.isEmpty) return;

    final ability = _selectAbility(hero);
    if (ability == null) {
      final enemy = aliveEnemies.first;
      final damage = _calculateDamage(hero, enemy);
      enemy.hp = max<int>(0, enemy.hp - damage);
      _battleLog.add("${hero.name} attacked ${enemy.name} for $damage damage!");
      if (enemy.hp <= 0) {
        _battleLog.add("${enemy.name} was defeated!");
      }
      return;
    }

    if (hero.mp < ability.mpCost || hero.sp < ability.spCost) {
      _battleLog.add(
          "${hero.name} does not have enough MP/SP to use ${ability.name}.");
      return;
    }

    hero.mp -= ability.mpCost;
    hero.sp -= ability.spCost;
    ability.cooldownTimer = ability.cooldown;
    _applyAbilityEffects(hero, ability, aliveEnemies);
    _battleLog.add("${hero.name} used ${ability.name}!");
  }

  AbilitiesModel? _selectAbility(GirlFarmer hero) {
    final availableAbilities = hero.abilities.where((ability) {
      return ability.cooldownTimer == 0;
    }).toList();

    if (availableAbilities.isEmpty) return null;

    final random = Random();
    return availableAbilities[random.nextInt(availableAbilities.length)];
  }

  void _applyAbilityEffects(
      GirlFarmer hero, AbilitiesModel ability, List<Enemy> enemies) {
    if (ability.attackBonus > 0) {
      final target = enemies.first;
      final damage = ability.attackBonus;
      target.hp = max<int>(0, target.hp - damage);
      _battleLog.add(
          "${hero.name} dealt $damage damage to ${target.name} with ${ability.name}!");
      if (target.hp <= 0) {
        _battleLog.add("${target.name} was defeated!");
      }
    }

    if (ability.hpBonus > 0) {
      hero.hp = min(hero.maxHp, hero.hp + ability.hpBonus);
      _battleLog.add(
          "${hero.name} healed for ${ability.hpBonus} HP with ${ability.name}!");
    }

    if (ability.defenseBonus != 0 || ability.agilityBonus != 0) {
      hero.defensePoints += ability.defenseBonus;
      hero.agilityPoints += ability.agilityBonus;
      _battleLog.add(
          "${hero.name} gained ${ability.defenseBonus} defense and ${ability.agilityBonus} agility with ${ability.name}!");
    }
  }

  Future<void> _processEnemyTurn(Enemy enemy) async {
    final aliveHeroes = _heroes!.where((hero) => hero.hp > 0).toList();
    if (aliveHeroes.isEmpty) return;

    final hero = aliveHeroes.reduce((a, b) => a.hp < b.hp ? a : b);
    final damage = _calculateDamage(enemy, hero);
    hero.hp = max<int>(0, hero.hp - damage);
    _battleLog.add("${enemy.name} attacked ${hero.name} for $damage damage!");
    if (hero.hp <= 0) {
      _battleLog.add("${hero.name} was defeated!");
    }
  }

  int _calculateDamage(dynamic attacker, dynamic defender) {
    final attackerAttack = attacker is GirlFarmer
        ? attacker.attackPoints
        : (attacker as Enemy).attackPoints;
    final defenderDefense = defender is GirlFarmer
        ? defender.defensePoints
        : (defender as Enemy).defensePoints;
    final baseDamage = max<int>(0, attackerAttack - defenderDefense);

    final attackerAgility = attacker is GirlFarmer
        ? attacker.agilityPoints
        : (attacker as Enemy).agilityPoints;
    final defenderAgility = defender is GirlFarmer
        ? defender.agilityPoints
        : (defender as Enemy).agilityPoints;
    final avoidChance = defenderAgility / (defenderAgility + attackerAgility);

    if (Random().nextDouble() < avoidChance) {
      _battleLog.add("${defender.name} avoided the attack!");
      return 0;
    }

    final criticalChance = attacker is GirlFarmer
        ? attacker.criticalPoint
        : (attacker as Enemy).criticalPoint;
    final random = Random();

    if (random.nextInt(100) < criticalChance) {
      final criticalMultiplier = 1.5;
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
