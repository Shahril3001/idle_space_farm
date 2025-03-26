import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/ability_model.dart';
import '../models/floor_model.dart';
import '../models/resource_model.dart';
import '../models/farm_model.dart';
import '../models/girl_farmer_model.dart';
import '../models/equipment_model.dart';
import '../repositories/farm_repository.dart';
import '../repositories/resource_repository.dart';
import '../repositories/item_repository.dart';
import '../repositories/girl_repository.dart';
import 'dart:async';
import 'dart:math';
import '../data/girl_data.dart'; // Import the girlsData list

class GameProvider with ChangeNotifier {
  final ResourceRepository _resourceRepository;
  final FarmRepository _farmRepository;
  final EquipmentRepository _equipmentRepository;
  final GirlRepository _girlRepository;

  bool _isInitialized = false;
  DateTime? _lastUpdateTime;
  Timer? _resourceTimer;

  bool get isInitialized => _isInitialized;

  GameProvider({
    required ResourceRepository resourceRepository,
    required FarmRepository farmRepository,
    required EquipmentRepository equipmentRepository,
    required GirlRepository girlRepository,
  })  : _resourceRepository = resourceRepository,
        _farmRepository = farmRepository,
        _equipmentRepository = equipmentRepository,
        _girlRepository = girlRepository {
    onAppStart();
  }

  double getCredits() =>
      _resourceRepository.getResourceByName('Credits')?.amount ?? 0.0;

  double getMinerals() =>
      _resourceRepository.getResourceByName('Minerals')?.amount ?? 0.0;

  double getEnergy() =>
      _resourceRepository.getResourceByName('Energy')?.amount ?? 0.0;

  bool exchangeResources(
      String from, String to, double fromAmount, double toAmount) {
    final fromResource = _resourceRepository.getResourceByName(from);
    final toResource = _resourceRepository.getResourceByName(to);

    if (fromResource != null && fromResource.amount >= fromAmount) {
      // Deduct from source
      fromResource.amount -= fromAmount;
      _resourceRepository.updateResource(fromResource);

      // Add to target
      toResource?.amount += toAmount;
      if (toResource != null) {
        _resourceRepository.updateResource(toResource);
      }

      notifyListeners();
      return true; // ✅ Successful exchange
    } else {
      return false; // ❌ Not enough resources
    }
  }

  Future<void> onAppStart() async {
    print("DEBUG: Initializing game data...");
    _initializeGameData();
    _loadLastUpdateTime();

    _isInitialized = true;
    Future.microtask(() {
      notifyListeners();
    });

    _calculateIdleResources();
    startResourceGeneration();
  }

  void _initializeGameData() {
    print("DEBUG: Initializing game data...");
    if (_resourceRepository.getAllResources().isEmpty) {
      _resourceRepository
          .addResource(Resource(name: 'Energy', amount: 1000000.0));
      _resourceRepository
          .addResource(Resource(name: 'Minerals', amount: 1000000.0));
      _resourceRepository
          .addResource(Resource(name: 'Credits', amount: 1000000.0));
    }

    if (_farmRepository.getAllFarms().isEmpty) {
      print("DEBUG: Initializing farms...");
      _initializeFarms();
    }
  }

  void _initializeFarms() {
    print("DEBUG: Initializing farms..."); // Add this line
    final solarFarm = Farm(
      name: 'Aetheris',
      resourcePerSecond: 1.0,
      unlockCost: 50.0,
      resourceType: 'Energy',
      upgradeCost: 50.0,
      position: Offset(110, 830), // Example position
    );

    final mineralExtractor = Farm(
      name: 'Eldoria',
      resourcePerSecond: 2.0,
      unlockCost: 100.0,
      resourceType: 'Minerals',
      upgradeCost: 100.0,
      position: Offset(370, 800), // Example position
    );

    // Add floors to farms
    for (int i = 1; i <= 25; i++) {
      solarFarm.floors
          .add(Floor(id: 'Floor $i', level: 1)); // ✅ Add default level
      mineralExtractor.floors
          .add(Floor(id: 'Floor $i', level: 1)); // ✅ Add default level
    }

    _farmRepository.addFarm(solarFarm);
    _farmRepository.addFarm(mineralExtractor);
  }

  void _loadLastUpdateTime() {
    // Load last update time from Hive or another storage if needed
  }

  List<Resource> get resources => _resourceRepository.getAllResources();
  List<Farm> get farms => _farmRepository.getAllFarms();
  List<GirlFarmer> get girlFarmers => _girlRepository.getAllGirls();
  List<Equipment> get equipment => _equipmentRepository.getAllEquipment();

  // Add a girl to the repository
  void addGirl(GirlFarmer girl) {
    _girlRepository.addGirl(girl);
    notifyListeners();
  }

  // Add equipment to the repository
  void addEquipment(Equipment equipment) {
    _equipmentRepository.addEquipment(equipment);
    notifyListeners();
  }

  // Perform equipment gacha
  List<Equipment> performEquipmentGacha({int pulls = 1}) {
    final credits = _resourceRepository.getResourceByName('Credits');
    final cost = pulls * 10;
    if (credits != null && credits.amount >= cost) {
      credits.amount -= cost;
      _resourceRepository.updateResource(credits);

      final random = Random();
      final items = <Equipment>[];

      for (var i = 0; i < pulls; i++) {
        final probability = random.nextDouble();
        if (probability < 0.10) {
          items.add(_getSpecialEquipment());
        } else {
          items.add(_getCommonEquipment());
        }
      }

      return items;
    }
    return []; // Not enough credits
  }

  Equipment _getCommonEquipment() {
    return Equipment(
      name: 'Common Tool',
      type: 'Common',
      statBoost: 0.1,
    );
  }

  Equipment _getSpecialEquipment() {
    return Equipment(
      name: 'Special Tool',
      type: 'Special',
      statBoost: 0.5,
    );
  }

  // Upgrade a farm
  void upgradeFarm(String farmName) {
    final farm = _farmRepository.getFarmByName(farmName);
    if (farm != null && farm.level < farm.maxLevel) {
      final resource = _resourceRepository.getResourceByName(farm.resourceType);
      if (resource != null && resource.amount >= farm.upgradeCost) {
        resource.amount -= farm.upgradeCost;
        farm.level++;
        farm.resourcePerSecond *= 1.2;
        _resourceRepository.updateResource(resource);
        _farmRepository.updateFarm(farm);
        notifyListeners();
      }
    }
  }

  String generateUniqueId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNumber = random.nextInt(10000);
    return '$timestamp-$randomNumber';
  }

  List<GirlFarmer> performGachaGirl({int pulls = 1}) {
    final credits = _resourceRepository.getResourceByName('Credits');
    final cost = pulls * 10;
    if (credits != null && credits.amount >= cost) {
      credits.amount -= cost;
      _resourceRepository.updateResource(credits);

      final random = Random();
      final girls = <GirlFarmer>[];

      for (var i = 0; i < pulls; i++) {
        final probability = random.nextDouble();
        List<GirlFarmer> availableGirls = [];

        if (probability < 0.05) {
          availableGirls =
              girlsData.where((girl) => girl.rarity == 'Unique').toList();
        } else if (probability < 0.30) {
          availableGirls =
              girlsData.where((girl) => girl.rarity == 'Rare').toList();
        } else {
          availableGirls =
              girlsData.where((girl) => girl.rarity == 'Common').toList();
        }

        if (availableGirls.isNotEmpty) {
          final selectedGirl =
              availableGirls[random.nextInt(availableGirls.length)];
          girls.add(GirlFarmer(
            id: generateUniqueId(), // Generate a unique ID
            name: selectedGirl.name,
            level: selectedGirl.level,
            miningEfficiency: selectedGirl.miningEfficiency,
            assignedFarm: selectedGirl.assignedFarm,
            rarity: selectedGirl.rarity,
            stars: selectedGirl.stars,
            image: selectedGirl.image,
            imageFace: selectedGirl.imageFace,
            attackPoints: selectedGirl.attackPoints,
            defensePoints: selectedGirl.defensePoints,
            agilityPoints: selectedGirl.agilityPoints,
            hp: selectedGirl.hp,
            mp: selectedGirl.mp,
            sp: selectedGirl.sp,
            maxHp: selectedGirl.hp,
            maxMp: selectedGirl.mp,
            maxSp: selectedGirl.sp,
            abilities:
                List<AbilitiesModel>.from(selectedGirl.abilities), // Deep copy
            race: selectedGirl.race,
            type: selectedGirl.type,
            region: selectedGirl.region,
            description: selectedGirl.description,
          ));
        }
      }

      // Debugging: Print pulled girls
      print("Pulled girls: ${girls.map((girl) => girl.name).toList()}");
      return girls;
    }
    return []; // Not enough credits
  }

  bool upgradeGirl(String girlId) {
    final girl = _girlRepository.getGirlById(girlId);
    final minerals = _resourceRepository.getResourceByName('Minerals');

    if (girl != null && minerals != null) {
      final int maxLevel = 100;
      if (girl.level >= maxLevel) {
        print("${girl.name} has reached the maximum level of $maxLevel.");
        return false;
      }

      final upgradeCost = (150 + (girl.level - 1) * 150).toInt();

      if (minerals.amount >= upgradeCost) {
        // Deduct minerals
        minerals.amount -= upgradeCost;
        _resourceRepository.updateResource(minerals);

        // Upgrade Girl
        girl.level++;

        // Increase miningEfficiency based on rarity
        switch (girl.rarity) {
          case 'Common':
            girl.miningEfficiency += (Random().nextDouble() * 0.03) + 0.01;
            break;
          case 'Rare':
            girl.miningEfficiency += (Random().nextDouble() * 0.03) + 0.04;
            break;
          case 'Unique':
            girl.miningEfficiency += (Random().nextDouble() * 0.02) + 0.08;
            break;
          default:
            girl.miningEfficiency += 0.01;
        }

        // Increase stats
        girl.attackPoints += 2;
        girl.defensePoints += 2;
        girl.agilityPoints += 1;
        girl.maxHp += 20;
        girl.hp = girl.maxHp;
        girl.maxMp += 10;
        girl.mp = girl.maxMp;
        girl.maxSp += 5;
        girl.sp = girl.maxSp;
        girl.criticalPoint += 1;

        // Unlock abilities based on level and race
        _unlockAbilities(girl);

        // Save the updated girl
        _girlRepository.updateGirl(girl);
        notifyListeners();
        return true;
      } else {
        print("Not enough minerals!");
        return false;
      }
    } else {
      print("Error: Girl or Minerals not found.");
      return false;
    }
  }

  void _unlockAbilities(GirlFarmer girl) {
    // First, handle race-specific ability unlocks
    switch (girl.race) {
      case "Human":
        _unlockHumanAbilities(girl);
        break;
      case "Eldren":
        _unlockEldrenAbilities(girl);
        break;
    }

    // Then handle class-specific ability unlocks
    switch (girl.type) {
      case "Divine Cleric":
        _unlockDivineClericAbilities(girl);
        break;
      case "Phantom Reaver":
        _unlockPhantomReaverAbilities(girl);
        break;
    }
  }

// Example race-specific ability unlocks
  void _unlockHumanAbilities(GirlFarmer girl) {
    switch (girl.level) {
      case 2:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "ability_001",
          name: "Second Wind",
          description: "Restores a small amount of HP.",
          hpBonus: 10,
          spCost: 5,
          cooldown: 4,
          type: AbilityType.heal,
          targetType: TargetType.single,
          affectsEnemies: false,
        ));
        break;
      case 5:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "ability_101",
          name: "Power Strike",
          description: "A strong basic attack.",
          hpBonus: 15,
          spCost: 5,
          cooldown: 3,
          type: AbilityType.attack,
          targetType: TargetType.single,
          affectsEnemies: true,
        ));
        break;
      // Add more level milestones as needed
    }
  }

  void _unlockEldrenAbilities(GirlFarmer girl) {
    switch (girl.level) {
      case 2:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "ability_002",
          name: "Nature's Blessing",
          description: "Increases agility and defense.",
          defenseBonus: 15,
          agilityBonus: 10,
          spCost: 10,
          cooldown: 3,
          type: AbilityType.buff,
          targetType: TargetType.single,
          affectsEnemies: false,
        ));
        break;
      case 5:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "ability_102",
          name: "Nature's Touch",
          description: "Minor healing from nature.",
          hpBonus: 10,
          mpCost: 8,
          cooldown: 4,
          type: AbilityType.heal,
          targetType: TargetType.single,
          affectsEnemies: false,
        ));
        break;
    }
  }

// Example class-specific ability unlocks
  void _unlockDivineClericAbilities(GirlFarmer girl) {
    switch (girl.level) {
      case 10:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "ability_016",
          name: "Holy Light",
          description:
              "A radiant light heals allies and damages undead enemies.",
          hpBonus: 25,
          mpCost: 15,
          cooldown: 5,
          type: AbilityType.heal,
          targetType: TargetType.all,
          affectsEnemies: false,
        ));
        break;
      case 15:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "ability_017",
          name: "Divine Shield",
          description: "Grants temporary immunity to damage for one turn.",
          defenseBonus: 50,
          mpCost: 20,
          cooldown: 8,
          type: AbilityType.buff,
          targetType: TargetType.single,
          affectsEnemies: false,
        ));
        break;
    }
  }

  void _unlockPhantomReaverAbilities(GirlFarmer girl) {
    switch (girl.level) {
      case 10:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "ability_019",
          name: "Phantom Slash",
          description:
              "A spectral blade cuts through enemies, ignoring some defense.",
          hpBonus: 20,
          criticalPoint: 15,
          mpCost: 12,
          cooldown: 4,
          type: AbilityType.attack,
          targetType: TargetType.single,
          affectsEnemies: true,
        ));
        break;
      case 15:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "ability_020",
          name: "Soul Drain",
          description: "Steals HP from an enemy and restores it to the user.",
          hpBonus: 15,
          mpCost: 10,
          cooldown: 5,
          type: AbilityType.attack,
          targetType: TargetType.single,
          affectsEnemies: true,
        ));
        break;
    }
  }

// Continue with other class-specific ability unlocks...

  // Sell Girl
  void sellGirl(String girlId) {
    final girl = _girlRepository.getGirlById(girlId);
    if (girl != null) {
      print("Unassigning girl $girlId from all farms...");
      for (var farm in _farmRepository.getAllFarms()) {
        for (var floor in farm.floors) {
          if (floor.assignedGirlId == girlId) {
            print(
                "Unassigning girl $girlId from ${farm.name}, floor ${floor.id}");
            floor.assignedGirlId = null;
            _farmRepository.updateFarm(farm);
          }
        }
      }

      final credits = _resourceRepository.getResourceByName('Credits');
      if (credits != null) {
        double sellPrice = 0;
        switch (girl.rarity) {
          case 'Common':
            sellPrice = 2.5;
            break;
          case 'Rare':
            sellPrice = 5;
            break;
          case 'Unique':
            sellPrice = 20;
            break;
        }
        sellPrice *= (1 + girl.attackPoints * 0.01);
        credits.amount += sellPrice;
        _resourceRepository.updateResource(credits);
        _girlRepository.deleteGirl(girlId);
        print("Sold girl $girlId for $sellPrice credits.");
        notifyListeners();
      }
    } else {
      print("Girl with ID $girlId not found.");
    }
  }

  bool unlockFloor(String farmName, String floorId) {
    print("Unlocking floor $floorId in farm $farmName");
    final farm = _farmRepository.getFarmByName(farmName);
    final minerals = _resourceRepository.getResourceByName('Minerals');

    if (farm != null && minerals != null) {
      final floor = farm.floors.firstWhere(
        (f) => f.id == floorId,
        orElse: () =>
            throw Exception("Floor $floorId not found in farm $farmName"),
      );

      // Calculate the unlock cost (same as upgradeGirl cost scaling)
      final unlockCost = (150 * pow(2, floor.level - 1)).toInt();

      print("Current Minerals: ${minerals.amount}");
      print("Unlock Cost: $unlockCost");

      if (minerals.amount >= unlockCost) {
        // ✅ Deduct minerals
        minerals.amount -= unlockCost;
        _resourceRepository.updateResource(minerals);

        // ✅ Unlock Floor
        floor.isUnlocked = true;
        _farmRepository.updateFarm(farm);

        print("Minerals After Unlock: ${minerals.amount}");
        print("Unlocked floor $floorId in farm $farmName");
        notifyListeners();
        return true; // Success
      } else {
        print("Not enough minerals to unlock floor!");
        return false; // Failure
      }
    } else {
      print("Error: Farm or Minerals not found.");
      return false; // Failure
    }
  }

  void assignGirlToFloor(String farmName, String floorId, String girlId) {
    print("Assigning girl $girlId to floor $floorId in farm $farmName");

    // Step 1: Unassign the girl from all farms and floors
    for (var farm in _farmRepository.getAllFarms()) {
      for (var floor in farm.floors) {
        if (floor.assignedGirlId == girlId) {
          print(
              "Girl $girlId is already assigned to ${farm.name}, floor ${floor.id}. Unassigning...");
          floor.assignedGirlId = null; // Unassign from previous farm
          _farmRepository.updateFarm(farm); // Update the farm state
        }
      }
    }

    // Step 2: Find the target farm
    final farm = _farmRepository.getFarmByName(farmName);
    if (farm != null) {
      final floor = farm.floors.firstWhere(
        (f) => f.id == floorId,
        orElse: () =>
            throw Exception("Floor $floorId not found in farm $farmName"),
      );

      // Step 3: Check if the floor is unlocked
      if (!floor.isUnlocked) {
        print(
            "Cannot assign girl $girlId to floor $floorId because it is locked.");
        return; // Block assignment if the floor is locked
      }

      // Step 4: Assign girl to the new floor
      floor.assignedGirlId = girlId;
      _farmRepository.updateFarm(farm); // Update the farm state
      print("Assigned girl $girlId to floor $floorId in farm $farmName");
      notifyListeners(); // Notify listeners to update the UI
    } else {
      print("Farm $farmName not found.");
    }
  }

  List<GirlFarmer> getUnassignedGirls(String farmName) {
    // Get all assigned girl IDs across all farms
    final assignedGirlIds = <String>{};
    for (var farm in _farmRepository.getAllFarms()) {
      for (var floor in farm.floors) {
        if (floor.assignedGirlId != null) {
          assignedGirlIds.add(floor.assignedGirlId!);
        }
      }
    }

    // Filter out the girls who are already assigned to any floor in any farm
    return girlFarmers
        .where((girl) => !assignedGirlIds.contains(girl.id))
        .toList();
  }

  // Clear Girl Assignment
  void clearGirlAssignment(GirlFarmer girl) {
    girl.assignedFarm = null;
    _girlRepository.updateGirl(girl);
    notifyListeners();
  }

  // Start Resource Generation
  void startResourceGeneration() {
    print("Starting resource generation timer...");
    _resourceTimer?.cancel();
    _resourceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      generateResources();
    });
  }

  // Generate Resources
  void generateResources() {
    print("Generating resources...");
    for (var farm in _farmRepository.getAllFarms()) {
      double totalMining = 0;

      for (var floor in farm.floors) {
        if (floor.isUnlocked && floor.assignedGirlId != null) {
          print("Floor ${floor.id} is unlocked and has an assigned girl.");
          final girl = _girlRepository.getGirlById(floor.assignedGirlId!);
          if (girl != null) {
            print(
                "Girl ${girl.name} has mining efficiency: ${girl.miningEfficiency}");
            // Consider other stats like attackPoints, defensePoints, etc.
            totalMining +=
                girl.miningEfficiency * (1 + girl.attackPoints * 0.01);
          } else {
            print("No girl found with ID: ${floor.assignedGirlId}");
          }
        }
      }

      final resource = _resourceRepository.getResourceByName(farm.resourceType);
      if (resource != null) {
        resource.amount += farm.resourcePerSecond * totalMining;
        _resourceRepository.updateResource(resource);
      } else {
        print("Resource ${farm.resourceType} not found.");
      }
    }
    notifyListeners();
  }

  // Calculate Idle Resources
  Future<void> _calculateIdleResources() async {
    if (_lastUpdateTime == null) return;

    final now = DateTime.now();
    final elapsedTime = now.difference(_lastUpdateTime!).inSeconds;

    if (elapsedTime > 0) {
      for (var farm in _farmRepository.getAllFarms()) {
        double totalMining = 0;

        for (var floor in farm.floors) {
          if (floor.isUnlocked && floor.assignedGirlId != null) {
            final girl = _girlRepository.getGirlById(floor.assignedGirlId!);
            if (girl != null) {
              // Consider other stats like attackPoints, defensePoints, etc.
              totalMining +=
                  girl.miningEfficiency * (1 + girl.attackPoints * 0.01);
            }
          }
        }

        final resource =
            _resourceRepository.getResourceByName(farm.resourceType);
        if (resource != null) {
          resource.amount += farm.resourcePerSecond * totalMining * elapsedTime;
          _resourceRepository.updateResource(resource);
        }
      }
      notifyListeners();
    }
  }

  void upgradeFloor(String farmName, String floorId) {
    final farm = _farmRepository.getFarmByName(farmName);
    if (farm != null) {
      final floor = farm.floors.firstWhere((f) => f.id == floorId);
      floor.level++; // Increase the floor level
      _farmRepository.updateFarm(farm); // Save the updated farm
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  void unassignGirlFromFloor(String farmName, String floorId) {
    final farm = _farmRepository.getFarmByName(farmName);
    if (farm != null) {
      final floor = farm.floors.firstWhere((f) => f.id == floorId);
      floor.assignedGirlId = null; // Remove the assigned girl
      _farmRepository.updateFarm(farm); // Save the updated farm
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  // Reset Resources
  void resetResources() {
    for (var resource in _resourceRepository.getAllResources()) {
      resource.amount = 0.0;
      _resourceRepository.updateResource(resource);
    }
    notifyListeners();
  }

  // Reset All Game Data
  void resetAllGameData() {
    resetResources();
    _farmRepository.clearAllFarms();
    _initializeFarms();
    _girlRepository.clearAllGirls();
    _equipmentRepository.clearAllEquipment();
    notifyListeners();
  }

  // On App Pause
  Future<void> onAppPause() async {
    _lastUpdateTime = DateTime.now();
    // Save last update time to Hive or another storage if needed
    _resourceTimer?.cancel();
  }

  @override
  void dispose() {
    _resourceTimer?.cancel();
    super.dispose();
  }
}
