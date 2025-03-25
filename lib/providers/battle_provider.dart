import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/ability_model.dart';
import '../models/girl_farmer_model.dart';
import '../models/enemy_model.dart';
import '../data/enemy_data.dart'; // Import the enemy_data.dart file

class BattleProvider with ChangeNotifier {
  // Constants
  static const int creditsPerEnemy = 50;

  // Battle state
  List<GirlFarmer>? _heroes;
  List<Enemy>? _enemies;
  bool _isBattleOver = false;
  String _battleResult = "";
  final List<String> _battleLog = [];
  bool _isProcessingTurn = false;
  Timer? _battleTimer;
  int _currentRound = 1; // Track the current round

  BattleProvider();

  // Getters
  List<GirlFarmer>? get heroes => _heroes;
  List<Enemy>? get enemies => _enemies;
  bool get isBattleOver => _isBattleOver;
  String get battleResult => _battleResult;
  List<String> get battleLog => _battleLog;
  bool get isProcessingTurn => _isProcessingTurn;
  int get currentRound => _currentRound; // Expose current round

  // Start a new battle
  void startBattle(
      List<GirlFarmer> heroes, int dungeonLevel, String difficulty) {
    print(
        "Starting battle with ${heroes.length} heroes and difficulty $difficulty");

    // Generate fresh enemies
    _enemies = generateEnemies(dungeonLevel, difficulty);

    // Reset heroes' HP to their max HP
    _heroes = heroes
        .map((hero) => GirlFarmer(
              id: hero.id, // Required field
              name: hero.name, // Required field
              level: hero.level, // Required field
              miningEfficiency: hero.miningEfficiency, // Required field
              assignedFarm: hero.assignedFarm, // Optional field
              rarity: hero.rarity, // Required field
              stars: hero.stars, // Required field
              image: hero.image, // Required field
              imageFace: hero.imageFace, // Required field
              attackPoints: hero.attackPoints, // Required field
              defensePoints: hero.defensePoints, // Required field
              agilityPoints: hero.agilityPoints, // Required field
              hp: hero.maxHp, // Reset HP to maxHp
              mp: hero.mp, // Required field
              sp: hero.sp, // Required field
              abilities: hero.abilities, // Required field
              race: hero.race, // Required field
              type: hero.type, // Required field
              region: hero.region, // Required field
              description: hero.description, // Required field
              maxHp: hero.maxHp, // Required field
              maxMp: hero.maxMp, // Required field
              maxSp: hero.maxSp, // Required field
              criticalPoint: hero.criticalPoint, // Required field
            ))
        .toList();

    // Reset battle state
    _isBattleOver = false;
    _battleResult = "";
    _battleLog.clear();
    _currentRound = 1;

    // Debug: Print hero and enemy HP to verify reset
    for (final hero in _heroes!) {
      print("Hero ${hero.name} HP after reset: ${hero.hp}");
    }
    for (final enemy in _enemies!) {
      print("Enemy ${enemy.name} HP: ${enemy.hp}");
    }

    notifyListeners();
  }

  // Reset the battle state
  void resetBattle(List<GirlFarmer> originalHeroes) {
    // Reset heroes' HP to their max HP
    _heroes = originalHeroes
        .map((hero) => GirlFarmer(
              id: hero.id, // Required field
              name: hero.name, // Required field
              level: hero.level, // Required field
              miningEfficiency: hero.miningEfficiency, // Required field
              assignedFarm: hero.assignedFarm, // Optional field
              rarity: hero.rarity, // Required field
              stars: hero.stars, // Required field
              image: hero.image, // Required field
              imageFace: hero.imageFace, // Required field
              attackPoints: hero.attackPoints, // Required field
              defensePoints: hero.defensePoints, // Required field
              agilityPoints: hero.agilityPoints, // Required field
              hp: hero.maxHp, // Reset HP to maxHp
              mp: hero.mp, // Required field
              sp: hero.sp, // Required field
              abilities: hero.abilities, // Required field
              race: hero.race, // Required field
              type: hero.type, // Required field
              region: hero.region, // Required field
              description: hero.description, // Required field
              maxHp: hero.maxHp, // Required field
              maxMp: hero.maxMp, // Required field
              maxSp: hero.maxSp, // Required field
              criticalPoint: hero.criticalPoint, // Required field
            ))
        .toList();

    // Clear enemies
    _enemies = null;

    // Reset battle state
    _isBattleOver = false;
    _battleResult = "";
    _battleLog.clear();
    _battleTimer?.cancel();
    _currentRound = 1;

    print("Battle reset: Heroes and enemies cleared. Ready for a new battle.");
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

    // Determine turn order based on agility
    final allParticipants = [..._heroes!, ..._enemies!];
    allParticipants.sort((a, b) {
      final aAgility =
          a is GirlFarmer ? a.agilityPoints : (a as Enemy).agilityPoints;
      final bAgility =
          b is GirlFarmer ? b.agilityPoints : (b as Enemy).agilityPoints;
      return bAgility.compareTo(aAgility);
    });

    // Process each participant's turn
    for (final participant in allParticipants) {
      if ((participant is GirlFarmer && participant.hp <= 0) ||
          (participant is Enemy && participant.hp <= 0)) {
        continue; // Skip if dead
      }

      if (participant is GirlFarmer) {
        await _processHeroTurn(participant);
      } else if (participant is Enemy) {
        await _processEnemyTurn(participant);
      }

      // Check if battle is over after each turn
      if (_checkBattleOver()) break;

      // Add delay for smooth execution
      await Future.delayed(Duration(milliseconds: 500));
      notifyListeners();
    }

    // Decrement cooldowns for all abilities
    for (final hero in _heroes!) {
      for (final ability in hero.abilities) {
        ability.updateCooldown();
      }
    }

    // Increment the round counter
    _currentRound++;
    notifyListeners();

    _isProcessingTurn = false;
    notifyListeners();
    print("Turn completed.");
  }

  // Process a hero's turn
  Future<void> _processHeroTurn(GirlFarmer hero) async {
    final aliveEnemies = _enemies!.where((enemy) => enemy.hp > 0).toList();
    if (aliveEnemies.isEmpty) return;

    // Randomly select an ability (or prioritize based on logic)
    final ability = _selectAbility(hero);
    if (ability == null) {
      // Fallback to basic attack if no ability is available
      final enemy = aliveEnemies.first;
      final damage = _calculateDamage(hero, enemy);
      enemy.hp = max<int>(0, enemy.hp - damage);
      _battleLog.add("${hero.name} attacked ${enemy.name} for $damage damage!");
      if (enemy.hp <= 0) {
        _battleLog.add("${enemy.name} was defeated!");
      }
      return;
    }

    // Check if the hero has enough MP/SP to use the ability
    if (hero.mp < ability.mpCost || hero.sp < ability.spCost) {
      _battleLog.add(
          "${hero.name} does not have enough MP/SP to use ${ability.name}.");
      return;
    }

    // Deduct MP/SP and apply cooldown
    hero.mp -= ability.mpCost;
    hero.sp -= ability.spCost;
    ability.cooldownTimer = ability.cooldown;

    // Apply the ability's effects
    _applyAbilityEffects(hero, ability, aliveEnemies);

    // Log the ability usage
    _battleLog.add("${hero.name} used ${ability.name}!");
  }

  // Helper function to select an ability
  AbilitiesModel? _selectAbility(GirlFarmer hero) {
    final availableAbilities = hero.abilities.where((ability) {
      return ability.cooldownTimer ==
          0; // Only select abilities with no cooldown
    }).toList();

    if (availableAbilities.isEmpty) return null;

    // Randomly select an ability
    final random = Random();
    return availableAbilities[random.nextInt(availableAbilities.length)];
  }

  // Helper function to apply ability effects
  void _applyAbilityEffects(
      GirlFarmer hero, AbilitiesModel ability, List<Enemy> enemies) {
    // Apply attack bonus
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

    // Apply healing
    if (ability.hpBonus > 0) {
      hero.hp = min(hero.maxHp, hero.hp + ability.hpBonus);
      _battleLog.add(
          "${hero.name} healed for ${ability.hpBonus} HP with ${ability.name}!");
    }

    // Apply buffs/debuffs
    if (ability.defenseBonus != 0 || ability.agilityBonus != 0) {
      hero.defensePoints += ability.defenseBonus;
      hero.agilityPoints += ability.agilityBonus;
      _battleLog.add(
          "${hero.name} gained ${ability.defenseBonus} defense and ${ability.agilityBonus} agility with ${ability.name}!");
    }
  }

  // Process an enemy's turn
  Future<void> _processEnemyTurn(Enemy enemy) async {
    final aliveHeroes = _heroes!.where((hero) => hero.hp > 0).toList();
    if (aliveHeroes.isEmpty) return;

    // Enemy targets the weakest hero (lowest HP)
    final hero = aliveHeroes.reduce((a, b) => a.hp < b.hp ? a : b);
    final damage = _calculateDamage(enemy, hero);
    hero.hp = max<int>(0, hero.hp - damage);
    _battleLog.add("${enemy.name} attacked ${hero.name} for $damage damage!");
    if (hero.hp <= 0) {
      _battleLog.add("${hero.name} was defeated!");
    }
  }

  // Calculate damage with a chance to avoid based on agility
  int _calculateDamage(dynamic attacker, dynamic defender) {
    // Base damage calculation
    final attackerAttack = attacker is GirlFarmer
        ? attacker.attackPoints
        : (attacker as Enemy).attackPoints;
    final defenderDefense = defender is GirlFarmer
        ? defender.defensePoints
        : (defender as Enemy).defensePoints;
    final baseDamage = max<int>(0, attackerAttack - defenderDefense);

    // Avoid chance based on agility
    final attackerAgility = attacker is GirlFarmer
        ? attacker.agilityPoints
        : (attacker as Enemy).agilityPoints;
    final defenderAgility = defender is GirlFarmer
        ? defender.agilityPoints
        : (defender as Enemy).agilityPoints;
    final avoidChance = defenderAgility / (defenderAgility + attackerAgility);

    // Check if the attack is avoided
    if (Random().nextDouble() < avoidChance) {
      _battleLog.add("${defender.name} avoided the attack!");
      return 0;
    }

    // Critical hit chance
    final criticalChance = attacker is GirlFarmer
        ? attacker.criticalPoint
        : (attacker as Enemy).criticalPoint;
    final random = Random();

    // Check if a critical hit occurs
    if (random.nextInt(100) < criticalChance) {
      final criticalMultiplier = 1.5; // 1.5x damage for critical hit
      final criticalDamage = (baseDamage * criticalMultiplier).toInt();
      _battleLog.add(
          "${attacker.name} landed a critical hit for $criticalDamage damage!");
      return criticalDamage;
    }

    // Normal damage
    _battleLog.add(
        "${attacker.name} attacked ${defender.name} for $baseDamage damage!");
    return baseDamage;
  }

  // Check if the battle is over
  bool _checkBattleOver() {
    if (_heroes!.every((hero) => hero.hp <= 0)) {
      print("Battle over: All heroes defeated");
      _isBattleOver = true;
      _battleResult = "Loss";
      _battleLog.add("Battle over! Player loses!");
      notifyListeners();
      return true;
    } else if (_enemies!.every((enemy) => enemy.hp <= 0)) {
      print("Battle over: All enemies defeated");
      _isBattleOver = true;
      _battleResult = "Win";
      _battleLog.add("Battle over! Player wins!");
      notifyListeners();
      return true;
    }
    return false;
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
