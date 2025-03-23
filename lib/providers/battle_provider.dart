import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../models/girl_farmer_model.dart';
import '../models/enemy_model.dart';
import '../repositories/enemy_repository.dart';
import '../data/enemy_data.dart'; // Import the enemy_data.dart file

class BattleProvider with ChangeNotifier {
  // Constants
  static const int maxRounds = 10;
  static const int creditsPerEnemy = 50;

  // Battle state
  List<GirlFarmer>? _heroes;
  List<Enemy>? _enemies;
  int _currentRound = 1;
  bool _isBattleOver = false;
  String _battleResult = "";
  final List<String> _battleLog = [];
  bool _isProcessingTurn = false;
  Timer? _battleTimer;

  final EnemyRepository _enemyRepository;

  BattleProvider({required EnemyRepository enemyRepository})
      : _enemyRepository = enemyRepository;

  // Getters
  List<GirlFarmer>? get heroes => _heroes;
  List<Enemy>? get enemies => _enemies;
  int get currentRound => _currentRound;
  bool get isBattleOver => _isBattleOver;
  String get battleResult => _battleResult;
  List<String> get battleLog => _battleLog;
  bool get isProcessingTurn => _isProcessingTurn;

  // Start a new battle
  void startBattle(
      List<GirlFarmer> heroes, int dungeonLevel, String difficulty) {
    print(
        "Starting battle with ${heroes.length} heroes and difficulty $difficulty");
    _heroes = heroes;
    _enemies =
        generateEnemies(dungeonLevel, difficulty); // Call the function directly
    _currentRound = 1;
    _isBattleOver = false;
    _battleResult = "";
    _battleLog.clear();
    notifyListeners();
  }

  // Simulate a turn in the battle with delays
  void nextTurn() async {
    if (_isBattleOver ||
        _heroes == null ||
        _enemies == null ||
        _isProcessingTurn) {
      print(
          "Cannot process turn: Battle over, heroes/enemies null, or already processing.");
      return;
    }

    print("Starting next turn...");
    _isProcessingTurn = true;
    notifyListeners();

    // Player's turn
    await _processTurn(_heroes!, _enemies!, (hero, enemy) {
      final damage = max<int>(0, hero.attackPoints - enemy.defensePoints);
      enemy.hp = max<int>(0, enemy.hp - damage);
      _battleLog.add("${hero.name} attacked ${enemy.name} for $damage damage!");
      if (enemy.hp <= 0) {
        _battleLog.add("${enemy.name} was defeated!");
      }
      print("${hero.name} attacked ${enemy.name}. Enemy HP: ${enemy.hp}");
    });

    // Add delay between player and enemy turns
    await Future.delayed(Duration(seconds: 1));

    // Enemy's turn
    await _processTurn(_enemies!, _heroes!, (enemy, hero) {
      final damage = max<int>(0, enemy.attackPoints - hero.defensePoints);
      hero.hp = max<int>(0, hero.hp - damage);
      _battleLog.add("${enemy.name} attacked ${hero.name} for $damage damage!");
      if (hero.hp <= 0) {
        _battleLog.add("${hero.name} was defeated!");
      }
      print("${enemy.name} attacked ${hero.name}. Hero HP: ${hero.hp}");
    });

    // Check if battle is over
    _checkBattleOver();

    // Increase round count
    if (!_isBattleOver) {
      _currentRound++;
      if (_currentRound > maxRounds) {
        _isBattleOver = true;
        _battleResult = (_heroes!.any((h) => h.hp > 0)) ? "Win" : "Loss";
        _battleLog.add(
            "Battle over! ${_battleResult == "Win" ? "Player wins!" : "Player loses!"}");
      }
      notifyListeners();
    }

    _isProcessingTurn = false;
    notifyListeners();
    print("Turn completed.");
  }

  // Helper method to process a turn for a list of attackers and defenders
  Future<void> _processTurn(List<dynamic> attackers, List<dynamic> defenders,
      Function(dynamic, dynamic) action) async {
    for (final attacker in attackers) {
      if (attacker.hp > 0) {
        // Filter out defenders with hp > 0
        final aliveDefenders =
            defenders.where((defender) => defender.hp > 0).toList();
        if (aliveDefenders.isEmpty) {
          // No alive defenders, skip this attacker
          continue;
        }

        // Select the first alive defender
        final defender = aliveDefenders.first;
        action(attacker, defender);

        // Add delay for smooth execution
        await Future.delayed(Duration(milliseconds: 500));
        notifyListeners();
      }
    }
  }

  // Simulate auto-battle
  void autoBattle() {
    if (_isBattleOver ||
        _heroes == null ||
        _enemies == null ||
        _isProcessingTurn) {
      print(
          "Cannot start auto-battle: Battle over, heroes/enemies null, or already processing.");
      return;
    }

    print("Starting auto-battle...");
    _battleTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isBattleOver) {
        timer.cancel();
        print("Auto-battle stopped: Battle is over.");
        return;
      }

      nextTurn();
    });
  }

  // Stop auto-battle
  void stopAutoBattle() {
    _battleTimer?.cancel();
  }

  // Check if the battle is over
  void _checkBattleOver() {
    if (_heroes!.every((hero) => hero.hp <= 0)) {
      print("Battle over: All heroes defeated");
      _isBattleOver = true;
      _battleResult = "Loss";
      _battleLog.add("Battle over! Player loses!");
    } else if (_enemies!.every((enemy) => enemy.hp <= 0)) {
      print("Battle over: All enemies defeated");
      _isBattleOver = true;
      _battleResult = "Win";
      _battleLog.add("Battle over! Player wins!");
    } else if (_currentRound > maxRounds) {
      print("Battle over: Maximum rounds reached");
      _isBattleOver = true;
      _battleResult = (_heroes!.any((h) => h.hp > 0)) ? "Win" : "Loss";
      _battleLog.add(
          "Battle over! ${_battleResult == "Win" ? "Player wins!" : "Player loses!"}");
    }
    notifyListeners();
  }

  // Reset the battle
  void resetBattle() {
    _heroes = null;
    _enemies = null;
    _currentRound = 1;
    _isBattleOver = false;
    _battleResult = "";
    _battleLog.clear();
    _battleTimer?.cancel();
    notifyListeners();
  }

  // Process rewards after battle
  void processRewards() {
    if (_battleResult == "Win") {
      final creditsEarned = _enemies!.length * creditsPerEnemy;
      _battleLog.add("Player wins! Earned $creditsEarned credits.");
      // Add rewards to the player's resources (e.g., via GameProvider)
    } else {
      _battleLog.add("Player loses. Better luck next time!");
    }
  }
}
