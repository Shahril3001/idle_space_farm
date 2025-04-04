import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/ability_model.dart';
import '../models/floor_model.dart';
import '../models/resource_model.dart';
import '../models/farm_model.dart';
import '../models/girl_farmer_model.dart';
import '../models/equipment_model.dart';
import '../repositories/ability_repository.dart';
import '../repositories/farm_repository.dart';
import '../repositories/resource_repository.dart';
import '../repositories/equipment_repository.dart';
import '../repositories/girl_repository.dart';
import 'dart:async';
import 'dart:math';
import '../data/girl_data.dart'; // Import the girlsData list
import '../data/equipment_data.dart';

class GameProvider with ChangeNotifier {
  final ResourceRepository _resourceRepository;
  final FarmRepository _farmRepository;
  final EquipmentRepository _equipmentRepository;
  final GirlRepository _girlRepository;
  final AbilityRepository _abilityRepository;

  bool _isInitialized = false;
  DateTime? _lastUpdateTime;
  Timer? _resourceTimer;

  bool get isInitialized => _isInitialized;

  GameProvider({
    required ResourceRepository resourceRepository,
    required FarmRepository farmRepository,
    required EquipmentRepository equipmentRepository,
    required GirlRepository girlRepository,
    required AbilityRepository abilityRepository,
  })  : _resourceRepository = resourceRepository,
        _farmRepository = farmRepository,
        _equipmentRepository = equipmentRepository,
        _girlRepository = girlRepository,
        _abilityRepository = abilityRepository {
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

    if (_girlRepository.getAllGirls().isEmpty) {
      print("DEBUG: Initializing girls...");
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

  // Add equipment to the repository
  void addEquipment(Equipment equipment) {
    try {
      _equipmentRepository.addEquipment(equipment);
      notifyListeners();
    } catch (e) {
      print('Error adding equipment: $e');
      // Consider rethrowing or handling the error appropriately
    }
  }

  /// Update equipment stats and persist changes
  void updateEquipment(Equipment equipment) {
    try {
      _equipmentRepository.updateEquipment(equipment);
      notifyListeners();
    } catch (e) {
      print('Error updating equipment: $e');
      // Handle error as needed
    }
  }

  /// Remove equipment permanently
  void deleteEquipment(String equipmentId) {
    try {
      _equipmentRepository.deleteEquipment(equipmentId);
      notifyListeners();
    } catch (e) {
      print('Error deleting equipment: $e');
      // Handle error as needed
    }
  }

  /// Get all equipment assigned to a specific girl
  List<Equipment> getGirlEquipment(String girlId) {
    return _equipmentRepository.getEquipmentByAssignedGirl(girlId);
  }

  /// Get all unassigned equipment
  List<Equipment> getAvailableEquipment() {
    return _equipmentRepository.getUnassignedEquipment();
  }

  /// Equip an item to a girl (automatically unequips any conflicting slot items)
  void equipToGirl(String equipmentId, String girlId) {
    final equipment = _equipmentRepository.getEquipmentById(equipmentId);
    if (equipment == null) return;

    // First unequip any items in the same slot
    final currentEquipment = _equipmentRepository
        .getEquipmentByAssignedGirl(girlId)
        .where((e) => e.slot == equipment.slot);

    for (final item in currentEquipment) {
      item.assignedTo = null;
      _equipmentRepository.updateEquipment(item);
    }

    // Equip the new item
    equipment.assignedTo = girlId;
    _equipmentRepository.updateEquipment(equipment);
    notifyListeners();
  }

  /// Unequip an item from any girl
  void unequipItem(String equipmentId) {
    final equipment = _equipmentRepository.getEquipmentById(equipmentId);
    if (equipment != null && equipment.assignedTo != null) {
      equipment.assignedTo = null;
      _equipmentRepository.updateEquipment(equipment);
      notifyListeners();
    }
  }

  /// Enhance equipment (increase stats)
  bool enhanceEquipment(String equipmentId) {
    final equipment = _equipmentRepository.getEquipmentById(equipmentId);
    if (equipment == null) return false;

    final cost = _calculateEnhancementCost(equipment);
    final credits = _resourceRepository.getResourceByName('Credits');

    if (credits == null || credits.amount < cost) {
      return false;
    }

    // Deduct cost
    credits.amount -= cost;
    _resourceRepository.updateResource(credits);

    // Enhance equipment
    equipment.enhancementLevel++;
    _equipmentRepository.updateEquipment(equipment);
    notifyListeners();

    return true;
  }

  /// Calculate enhancement cost based on current level and rarity
  double _calculateEnhancementCost(Equipment equipment) {
    return 100 *
        (equipment.enhancementLevel + 1) *
        (equipment.rarity.index + 1);
  }

  /// Calculate sell value based on rarity and enhancements
  double calculateSellValue(Equipment equipment) {
    final baseValue = switch (equipment.rarity) {
      EquipmentRarity.common => 50,
      EquipmentRarity.uncommon => 100,
      EquipmentRarity.rare => 250,
      EquipmentRarity.epic => 500,
      EquipmentRarity.legendary => 1000,
      EquipmentRarity.mythic => 2500,
    };
    return baseValue * (1 + equipment.enhancementLevel * 0.5);
  }

  /// Sell equipment and get credits
  bool sellEquipment(String equipmentId) {
    final equipment = _equipmentRepository.getEquipmentById(equipmentId);
    if (equipment == null) return false;

    // Unequip first if needed
    if (equipment.assignedTo != null) {
      unequipItem(equipmentId);
    }

    // Add credits
    final sellValue = calculateSellValue(equipment);
    final credits = _resourceRepository.getResourceByName('Credits');
    if (credits != null) {
      credits.amount += sellValue;
      _resourceRepository.updateResource(credits);
    }

    // Remove equipment
    _equipmentRepository.deleteEquipment(equipmentId);
    notifyListeners();

    return true;
  }

  /// Filter equipment with multiple criteria
  List<Equipment> filterEquipment({
    String? searchQuery,
    EquipmentSlot? slot,
    EquipmentRarity? rarity,
    bool? onlyAssigned,
    bool? onlyUnassigned,
    int? minEnhancement,
    int? maxEnhancement,
  }) {
    return _equipmentRepository.getFilteredEquipment(
      searchTerm: searchQuery,
      slot: slot,
      rarity: rarity,
      isAssigned:
          onlyAssigned != null ? true : (onlyUnassigned != null ? false : null),
      minEnhancementLevel: minEnhancement,
      maxEnhancementLevel: maxEnhancement,
    );
  }

  List<Equipment> performEquipmentGacha({int pulls = 1}) {
    final credits = _resourceRepository.getResourceByName('Credits');
    final cost = pulls * 10;

    if (credits == null || credits.amount < cost) return [];

    credits.amount -= cost;
    _resourceRepository.updateResource(credits);

    final items = <Equipment>[];
    final random = Random();

    for (var i = 0; i < pulls; i++) {
      final roll = random.nextDouble();
      final rarity = _determineRarity(roll);

      // Get all equipment of this rarity from predefined list
      final possibleDrops =
          equipmentList.where((e) => e.rarity == rarity).toList();

      if (possibleDrops.isEmpty) {
        // Fallback to creating random equipment if no predefined ones exist
        final slot = _determineSlot(random);
        final equipment = _createEquipment(rarity, slot, random);
        if (equipment != null) {
          items.add(equipment);
          _equipmentRepository.addEquipment(equipment);
        }
      } else {
        // Select random equipment from predefined list
        final equipment = possibleDrops[random.nextInt(possibleDrops.length)];

        // Create a new instance with unique ID
        final newEquipment = Equipment(
          id: '${equipment.id}_${DateTime.now().millisecondsSinceEpoch}',
          name: equipment.name,
          slot: equipment.slot,
          rarity: equipment.rarity,
          attackBonus: equipment.attackBonus,
          defenseBonus: equipment.defenseBonus,
          hpBonus: equipment.hpBonus,
          agilityBonus: equipment.agilityBonus,
          enhancementLevel: 0, // Start unenhanced
          allowedTypes: List.from(equipment.allowedTypes),
          allowedRaces: List.from(equipment.allowedRaces),
          isTradable: equipment.isTradable,
          mpBonus: equipment.mpBonus,
          spBonus: equipment.spBonus,
          criticalPoint: equipment.criticalPoint,
        );

        items.add(newEquipment);
        _equipmentRepository.addEquipment(newEquipment);
      }
    }

    notifyListeners();
    return items;
  }

  EquipmentRarity _determineRarity(double roll) {
    assert(roll >= 0 && roll <= 1, 'Roll must be between 0 and 1');

    return switch (roll) {
      < 0.01 => EquipmentRarity.mythic, // 1%
      < 0.06 => EquipmentRarity.legendary, // 5%
      < 0.16 => EquipmentRarity.epic, // 10%
      < 0.36 => EquipmentRarity.rare, // 20%
      < 0.66 => EquipmentRarity.uncommon, // 30%
      _ => EquipmentRarity.common // 34%
    };
  }

  EquipmentSlot _determineSlot(Random random) {
    try {
      return EquipmentSlot.values[random.nextInt(EquipmentSlot.values.length)];
    } catch (e) {
      print('Error determining slot: $e');
      return EquipmentSlot.weapon; // Default fallback
    }
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  String _getSlotName(EquipmentSlot slot) {
    return switch (slot) {
      EquipmentSlot.weapon => 'Weapon',
      EquipmentSlot.armor => 'Armor',
      EquipmentSlot.accessory => 'Accessory',
    };
  }

  Equipment? _createEquipment(
      EquipmentRarity rarity, EquipmentSlot slot, Random random) {
    try {
      final baseValue = switch (rarity) {
        EquipmentRarity.common => 5,
        EquipmentRarity.uncommon => 10,
        EquipmentRarity.rare => 20,
        EquipmentRarity.epic => 35,
        EquipmentRarity.legendary => 50,
        EquipmentRarity.mythic => 75,
      };

      // Common equipment types for variety
      final weaponTypes = ['Sword', 'Axe', 'Mace', 'Dagger', 'Bow'];
      final armorTypes = ['Plate', 'Mail', 'Leather', 'Robe', 'Cloak'];
      final accessoryTypes = [
        'Amulet',
        'Ring',
        'Bracelet',
        'Talisman',
        'Charm'
      ];

      final now = DateTime.now().millisecondsSinceEpoch;
      final capitalizedRarity = _capitalize(rarity.name);

      return switch (slot) {
        EquipmentSlot.weapon => Equipment(
            id: '${rarity.name}_weapon_$now',
            name:
                '$capitalizedRarity ${weaponTypes[random.nextInt(weaponTypes.length)]}',
            slot: slot,
            rarity: rarity,
            attackBonus: baseValue,
            defenseBonus: baseValue ~/ 4,
            // Ensure all required fields are included
            hpBonus: 0,
            agilityBonus: 0,
            enhancementLevel: 0,
            allowedTypes: [],
            allowedRaces: [],
            isTradable: true,
            mpBonus: 0,
            spBonus: 0,
            criticalPoint: 0,
          ),
        EquipmentSlot.armor => Equipment(
            id: '${rarity.name}_armor_$now',
            name:
                '$capitalizedRarity ${armorTypes[random.nextInt(armorTypes.length)]}',
            slot: slot,
            rarity: rarity,
            defenseBonus: baseValue,
            hpBonus: baseValue ~/ 2,
            // Ensure all required fields are included
            attackBonus: 0,
            agilityBonus: 0,
            enhancementLevel: 0,
            allowedTypes: [],
            allowedRaces: [],
            isTradable: true,
            mpBonus: 0,
            spBonus: 0,
            criticalPoint: 0,
          ),
        EquipmentSlot.accessory => Equipment(
            id: '${rarity.name}_accessory_$now',
            name:
                '$capitalizedRarity ${accessoryTypes[random.nextInt(accessoryTypes.length)]}',
            slot: slot,
            rarity: rarity,
            agilityBonus: baseValue,
            hpBonus: baseValue ~/ 3,
            // Ensure all required fields are included
            attackBonus: 0,
            defenseBonus: 0,
            enhancementLevel: 0,
            allowedTypes: [],
            allowedRaces: [],
            isTradable: true,
            mpBonus: 0,
            spBonus: 0,
            criticalPoint: 0,
          ),
      };
    } catch (e) {
      print('Error creating equipment: $e');
      return null;
    }
  }

  /// Helper to get random equipment slot (used by your existing performEquipmentGacha)
  EquipmentSlot getRandomEquipmentSlot(Random random) {
    return _determineSlot(random);
  }

  /// Helper to create random equipment (used by your existing performEquipmentGacha)
  Equipment? createRandomEquipment(
      EquipmentRarity rarity, EquipmentSlot slot, Random random) {
    return _createEquipment(rarity, slot, random);
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

  // Add a girl to the repository
  void addGirl(GirlFarmer girl) {
    _girlRepository.addGirl(girl);
    notifyListeners();
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
        final availableGirls = _getGirlsByRarity(random.nextDouble());

        if (availableGirls.isNotEmpty) {
          final selectedGirl =
              availableGirls[random.nextInt(availableGirls.length)];
          final newGirl = _createGirlFromTemplate(selectedGirl);

          // Directly add to repository (no need for saveAllGirls)
          _girlRepository.addGirl(newGirl);
          girls.add(newGirl);

          print(
              'Summoned ${newGirl.name} with ${newGirl.abilities.length} abilities:');
          newGirl.abilities
              .forEach((a) => print('- ${a.name} (${a.abilitiesID})'));
        }
      }

      notifyListeners();
      return girls;
    }
    return [];
  }

  List<GirlFarmer> _getGirlsByRarity(double probability) {
    if (probability < 0.05) {
      return girlsData.where((girl) => girl.rarity == 'Unique').toList();
    } else if (probability < 0.30) {
      return girlsData.where((girl) => girl.rarity == 'Rare').toList();
    }
    return girlsData.where((girl) => girl.rarity == 'Common').toList();
  }

  GirlFarmer _createGirlFromTemplate(GirlFarmer template) {
    return GirlFarmer(
      id: generateUniqueId(),
      name: template.name,
      level: template.level,
      miningEfficiency: template.miningEfficiency,
      rarity: template.rarity,
      stars: template.stars,
      image: template.image,
      imageFace: template.imageFace,
      attackPoints: template.attackPoints,
      defensePoints: template.defensePoints,
      agilityPoints: template.agilityPoints,
      hp: template.hp,
      mp: template.mp,
      sp: template.sp,
      maxHp: template.hp,
      maxMp: template.mp,
      maxSp: template.sp,
      abilities: _initializeAbilities(template.race, template.abilities),
      race: template.race,
      type: template.type,
      region: template.region,
      description: template.description,
      criticalPoint: template.criticalPoint,
      currentCooldowns: {},
      elementAffinities: template.elementAffinities,
      statusEffects: [],
      partyMemberIds: [],
      equippedItems: [],
    );
  }

  List<AbilitiesModel> _initializeAbilities(
      String race, List<AbilitiesModel> templateAbilities) {
    // Always create fresh copies of abilities
    return templateAbilities.map((ability) => ability.freshCopy()).toList();

    // OR use RaceAbilities if you want to ensure standard starters:
    // return RaceAbilities.getStarterAbilities(race);
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
      case "Therian":
        _unlockTherianAbilities(girl);
        break;
      case "Dracovar":
        _unlockDracovarAbilities(girl);
        break;
      case "Daemon":
        _unlockDaemonAbilities(girl);
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
      case 15:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "human_002",
          name: "Tactical Strike",
          description: "A precise attack that ignores some defense.",
          hpBonus: 25,
          spCost: 8,
          cooldown: 3,
          type: AbilityType.attack,
          targetType: TargetType.single,
          affectsEnemies: true,
          criticalPoint: 15,
        ));
        break;
      case 35:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "human_003",
          name: "Rallying Cry",
          description: "Boosts attack of all allies for 3 turns.",
          attackBonus: 15,
          spCost: 12,
          cooldown: 5,
          type: AbilityType.buff,
          targetType: TargetType.all,
          affectsEnemies: false,
        ));
        break;
      case 55:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "human_004",
          name: "Last Stand",
          description: "When HP is below 30%, gain 50% defense and 20% attack.",
          defenseBonus: 50,
          attackBonus: 20,
          spCost: 15,
          cooldown: 7,
          type: AbilityType.buff,
          targetType: TargetType.single,
          affectsEnemies: false,
        ));
        break;
      case 80:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "human_005",
          name: "Heroic Sacrifice",
          description:
              "Deals massive damage to one enemy but reduces user's HP to 1.",
          hpBonus: 999, // Special handling needed in code
          spCost: 25,
          cooldown: 10,
          type: AbilityType.attack,
          targetType: TargetType.single,
          affectsEnemies: true,
          criticalPoint: 30,
        ));
        break;
    }
  }

  void _unlockEldrenAbilities(GirlFarmer girl) {
    switch (girl.level) {
      case 15:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "eldren_002",
          name: "Sylvan Arrow",
          description: "A magical arrow that never misses its mark.",
          hpBonus: 20,
          spCost: 7,
          cooldown: 2,
          type: AbilityType.attack,
          targetType: TargetType.single,
          affectsEnemies: true,
          criticalPoint: 20, // Higher crit chance
        ));
        break;
      case 35:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "eldren_003",
          name: "Moonlight Veil",
          description:
              "Creates a protective barrier that absorbs damage for all allies.",
          defenseBonus: 30,
          spCost: 18,
          cooldown: 6,
          type: AbilityType.buff,
          targetType: TargetType.all,
          affectsEnemies: false,
        ));
        break;
      case 55:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "eldren_004",
          name: "Ancient Whisper",
          description:
              "Silences all enemies for 2 turns, preventing magic use.",
          spCost: 20,
          cooldown: 8,
          type: AbilityType.debuff,
          targetType: TargetType.all,
          affectsEnemies: true,
        ));
        break;
      case 80:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "eldren_005",
          name: "World Tree's Gift",
          description:
              "Revives all fallen allies with 50% HP and clears debuffs.",
          hpBonus: 50, // For revived allies
          spCost: 30,
          cooldown: 15,
          type: AbilityType.heal,
          targetType: TargetType.all,
          affectsEnemies: false,
        ));
        break;
    }
  }

  void _unlockTherianAbilities(GirlFarmer girl) {
    switch (girl.level) {
      case 15:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "therian_002",
          name: "Claw Swipe",
          description: "A rapid series of slashes that hit multiple times.",
          hpBonus: 15,
          spCost: 5,
          cooldown: 2,
          type: AbilityType.attack,
          targetType: TargetType.single,
          affectsEnemies: true,
          criticalPoint: 25, // Multi-hit with crit chance
        ));
        break;
      case 35:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "therian_003",
          name: "Pack Tactics",
          description: "Increases damage for each living ally (up to +50%).",
          attackBonus: 10, // Base + scaling per ally
          spCost: 15,
          cooldown: 5,
          type: AbilityType.buff,
          targetType: TargetType.single,
          affectsEnemies: false,
        ));
        break;
      case 55:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "therian_004",
          name: "Primal Howl",
          description:
              "Reduces all enemies' defense and causes fear (miss chance).",
          defenseBonus: -20, // Debuff
          spCost: 18,
          cooldown: 7,
          type: AbilityType.debuff,
          targetType: TargetType.all,
          affectsEnemies: true,
        ));
        break;
      case 80:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "therian_005",
          name: "Blood Moon Frenzy",
          description:
              "Enters unstoppable frenzy for 3 turns, but loses 10% HP per turn.",
          attackBonus: 40,
          agilityBonus: 20,
          hpBonus: -10, // HP cost per turn
          spCost: 25,
          cooldown: 12,
          type: AbilityType.buff,
          targetType: TargetType.single,
          affectsEnemies: false,
        ));
        break;
    }
  }

  void _unlockDracovarAbilities(GirlFarmer girl) {
    switch (girl.level) {
      case 15:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "dracovar_002",
          name: "Scales of Protection",
          description: "Hardens dragon scales to reduce incoming damage.",
          defenseBonus: 25,
          spCost: 10,
          cooldown: 4,
          type: AbilityType.buff,
          targetType: TargetType.single,
          affectsEnemies: false,
        ));
        break;
      case 35:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "dracovar_003",
          name: "Wing Buffet",
          description:
              "Powerful wings knock back enemies, delaying their turns.",
          agilityBonus: -15, // Reduces enemy agility
          spCost: 12,
          cooldown: 6,
          type: AbilityType.debuff,
          targetType: TargetType.all,
          affectsEnemies: true,
        ));
        break;
      case 55:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "dracovar_004",
          name: "Draconic Awakening",
          description:
              "Temporarily unlocks true dragon form, boosting all stats.",
          attackBonus: 20,
          defenseBonus: 20,
          agilityBonus: 15,
          hpBonus: 30,
          spCost: 20,
          cooldown: 8,
          type: AbilityType.buff,
          targetType: TargetType.single,
          affectsEnemies: false,
        ));
        break;
      case 80:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "dracovar_005",
          name: "Apocalypse Flame",
          description:
              "Unleashes a devastating firestorm that burns enemies for 3 turns.",
          hpBonus: 40,
          spCost: 30,
          cooldown: 15,
          type: AbilityType.attack,
          targetType: TargetType.all,
          affectsEnemies: true,
          criticalPoint: 20,
        ));
        break;
    }
  }

  void _unlockDaemonAbilities(GirlFarmer girl) {
    switch (girl.level) {
      case 15:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "daemon_002",
          name: "Hellfire Blast",
          description: "Unleashes a torrent of hellfire on all enemies.",
          hpBonus: 25, // Damage value
          mpCost: 15,
          cooldown: 4,
          type: AbilityType.attack,
          targetType: TargetType.all,
          affectsEnemies: true,
          criticalPoint: 15,
        ));
        break;
      case 35:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "daemon_004",
          name: "Soul Drain",
          description: "Steals life force from an enemy, healing the caster.",
          hpBonus: 20, // Damage dealt and HP drained
          mpCost: 12,
          cooldown: 3,
          type: AbilityType.attack,
          targetType: TargetType.single,
          affectsEnemies: true,
          drainsHealth: true, // Enables lifesteal
          criticalPoint: 15,
        ));
        break;
      case 55:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "daemon_003",
          name: "Demonic Pact",
          description: "Sacrifices HP to greatly increase attack power.",
          hpBonus: -15, // HP cost
          attackBonus: 20,
          spCost: 10,
          cooldown: 5,
          type: AbilityType.buff,
          targetType: TargetType.single,
          affectsEnemies: false,
        ));
        break;
      case 80:
        girl.addAbility(AbilitiesModel(
          abilitiesID: "daemon_006",
          name: "Dark Regeneration",
          description: "Channels dark energy to restore health over time.",
          hpBonus: 30,
          mpCost: 20,
          cooldown: 6,
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
// Inside GameProvider class

// Save the current game state
  Future<bool> saveGame() async {
    try {
      // Save resources
      final resources = _resourceRepository.getAllResources();
      await _resourceRepository.saveAllResources(resources);

      // Save farms
      final girls = _girlRepository.getAllGirls();
      await _girlRepository.saveAllGirls(girls);

      // Save girls
      final farms = _farmRepository.getAllFarms();
      await _farmRepository.saveAllFarms(farms);

      // Save equipment
      final equipment = _equipmentRepository.getAllEquipment();
      await _equipmentRepository.saveAllEquipment(equipment);

      // Save timestamp
      await Hive.box('idle_space_farm')
          .put('lastSaved', DateTime.now().toIso8601String());

      return true;
    } catch (e) {
      print('Error saving game: $e');
      return false;
    }
  }

  Future<bool> loadGame() async {
    try {
      final box = await Hive.openBox('idle_space_farm');

      // Check if save exists
      if (!box.containsKey('lastSaved')) {
        return false;
      }

      // Load resources
      final savedResources = (box.get('resources', defaultValue: []) as List)
          .cast<Map<String, dynamic>>();
      _resourceRepository.clearAllResources();
      for (var resourceMap in savedResources) {
        _resourceRepository.addResource(Resource.fromMap(resourceMap));
      }

      // Load farms
      final savedFarms = (box.get('farms', defaultValue: []) as List)
          .cast<Map<String, dynamic>>();
      _farmRepository.clearAllFarms();
      for (var farmMap in savedFarms) {
        _farmRepository.addFarm(Farm.fromMap(farmMap));
      }

      // Load girls
      final savedGirls = (box.get('girls', defaultValue: []) as List)
          .cast<Map<String, dynamic>>();
      _girlRepository.clearAllGirls();
      for (var girlMap in savedGirls) {
        _girlRepository.addGirl(GirlFarmer.fromMap(girlMap));
      }

      // Load equipment
      final savedEquipment = (box.get('equipment', defaultValue: []) as List)
          .cast<Map<String, dynamic>>();
      _equipmentRepository.clearAllEquipment();
      for (var equipmentMap in savedEquipment) {
        _equipmentRepository.addEquipment(Equipment.fromMap(equipmentMap));
      }

      _lastUpdateTime = DateTime.parse(box.get('lastSaved') as String);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error loading game: $e');
      return false;
    }
  }

// Delete the saved game
  Future<bool> deleteSave() async {
    try {
      final box = await Hive.openBox('idle_space_farm');
      await box.clear();
      resetAllGameData(); // Reset to default state
      return true;
    } catch (e) {
      print('Error deleting save: $e');
      return false;
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
