import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/ability_data.dart';
import '../data/potion_data.dart';
import '../models/ability_model.dart';
import '../models/floor_model.dart';
import '../models/potion_model.dart';
import '../models/resource_model.dart';
import '../models/farm_model.dart';
import '../models/girl_farmer_model.dart';
import '../models/equipment_model.dart';
import '../models/shop_model.dart';
import '../repositories/ability_repository.dart';
import '../repositories/farm_repository.dart';
import '../repositories/potion_model.dart';
import '../repositories/resource_repository.dart';
import '../repositories/equipment_repository.dart';
import '../repositories/girl_repository.dart';
import 'dart:async';
import 'dart:math';
import '../data/girl_data.dart'; // Import the girlsData list
import '../data/equipment_data.dart';
import '../repositories/shop_repository.dart';

class GameProvider with ChangeNotifier {
  final ResourceRepository _resourceRepository;
  final FarmRepository _farmRepository;
  final EquipmentRepository _equipmentRepository;
  final GirlRepository _girlRepository;
  final AbilityRepository _abilityRepository;
  final ShopRepository _shopRepository;
  final PotionRepository _potionRepository;

  bool _isInitialized = false;
  DateTime? _lastUpdateTime;
  Timer? _resourceTimer;

  Timer? _dailyCheckTimer;

  ShopModel? _shop;
  bool _isShopLoading = false;
  bool get isInitialized => _isInitialized;
  ShopModel? get shop => _shop;
  OverlayEntry? _currentOverlay;

  GameProvider({
    required ResourceRepository resourceRepository,
    required FarmRepository farmRepository,
    required EquipmentRepository equipmentRepository,
    required GirlRepository girlRepository,
    required AbilityRepository abilityRepository,
    required ShopRepository shopRepository,
    required PotionRepository potionRepository,
  })  : _resourceRepository = resourceRepository,
        _farmRepository = farmRepository,
        _equipmentRepository = equipmentRepository,
        _girlRepository = girlRepository,
        _abilityRepository = abilityRepository,
        _shopRepository = shopRepository,
        _potionRepository = potionRepository {
    _initializeGame();
    onAppStart();
  }

  Future<void> _initializeGame() async {
    _isInitialized = true;
    notifyListeners();
  }

  bool get isShopLoading => _isShopLoading;
  List<ShopCategory> get shopCategories => _shop?.categories ?? [];

  Future<void> initializeShop() async {
    startDailyRefreshCheck();
    if (_isShopLoading) {
      debugPrint('Shop initialization already in progress - aborting');
      return;
    }

    _isShopLoading = true;
    notifyListeners();
    debugPrint('Starting shop initialization...');

    try {
      debugPrint('Loading shop from repository...');
      await _shopRepository.initializeDefaultShop();
      _shop = _shopRepository.getShop();

      if (_shop == null) {
        debugPrint('No shop found in repository, creating default shop...');
        _shop = ShopModel(categories: createDefaultShopCategories());
        await _shopRepository.saveShop(_shop!);
        debugPrint('Default shop created and saved');
      } else {
        debugPrint('Shop loaded from repository successfully');
        debugPrint('Shop contains ${_shop!.categories.length} categories');
        _shop!.categories.forEach((category) {
          debugPrint(
              'Category "${category.name}" has ${category.items.length} items');
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error initializing shop: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('Falling back to default shop');
      _shop = ShopModel(categories: createDefaultShopCategories());
    } finally {
      _isShopLoading = false;
      notifyListeners();
      debugPrint('Shop initialization complete');
    }
  }

  void startDailyRefreshCheck() {
    _dailyCheckTimer?.cancel();
    // Check every hour for daily reset
    _dailyCheckTimer = Timer.periodic(Duration(hours: 1), (_) {
      checkDailyReset();
    });
  }

  void checkDailyReset() {
    if (_shop == null) return;

    final now = DateTime.now();
    if (!_shop!.isSameDay(now, _shop!.lastDailyReset)) {
      _shop!.refreshShop(createDefaultShopCategories());
      _shopRepository.saveShop(_shop!);
      notifyListeners();
    }
  }

  void setCurrentOverlay(OverlayEntry overlay) {
    // Remove any existing overlay before setting a new one
    _currentOverlay?.remove();
    _currentOverlay = overlay;
  }

  void removeCurrentOverlay() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  Future<void> manualRefreshShop() async {
    if (_shop == null || !_shop!.canRefresh) return;

    _shop!.refreshShop(createDefaultShopCategories());
    await _shopRepository.saveShop(_shop!);
    notifyListeners();
  }

  bool isItemPurchased(String itemId) {
    return _shop?.purchasedItemIds.contains(itemId) ?? false;
  }

  bool canAffordItem(ShopItem item) {
    return canAfford(item.prices);
  }

  int getMaxAffordableQuantity(ShopItem item) {
    if (_shop == null) return 0;

    // Calculate the maximum quantity based on each required resource
    int maxQuantity = -1;

    item.prices.forEach((currency, pricePerUnit) {
      final resource = _resourceRepository.getResourceByName(currency);
      if (resource == null) {
        maxQuantity = 0;
        return;
      }

      // For each resource, calculate how many we can buy
      final possibleQuantity = (resource.amount / pricePerUnit).floor();

      // Take the minimum across all resources
      if (maxQuantity == -1 || possibleQuantity < maxQuantity) {
        maxQuantity = possibleQuantity;
      }
    });

    // Consider stock limitations if they exist
    if (item.stock != null && item.stock! < maxQuantity) {
      maxQuantity = item.stock!;
    }

    // Ensure we don't return negative values
    return maxQuantity.clamp(0, 99); // Assuming 99 is max stack size
  }

  Future<bool> purchaseItem(ShopItem item, {int quantity = 1}) async {
    if (_shop == null || quantity <= 0) return false;

    // Calculate total cost
    final totalCost = <String, int>{};
    item.prices.forEach((currency, amount) {
      totalCost[currency] = amount * quantity;
    });

    // Check affordability
    if (!canAfford(totalCost)) return false;

    try {
      // Deduct resources
      deductResources(totalCost);

      // Handle the specific item type
      switch (item.type) {
        case ShopItemType.girl:
          if (quantity > 1) {
            throw Exception("Cannot purchase multiple girls at once");
          }
          await _handleGirlPurchase(item);
          break;
        case ShopItemType.equipment:
          if (quantity > 1) {
            throw Exception("Cannot purchase multiple equipment at once");
          }
          await _handleEquipmentPurchase(item);
          break;
        case ShopItemType.potion:
          await _handlePotionPurchase(item, quantity: quantity);
          break;
        case ShopItemType.abilityScroll:
          if (quantity > 1) {
            throw Exception("Cannot purchase multiple ability scrolls at once");
          }
          await _handleAbilityScrollPurchase(item);
          break;
      }

      // Update stock if applicable
      if (item.stock != null) {
        final newStock = item.stock! - quantity;
        final updatedItem = item.copyWith(stock: newStock);
        if (newStock <= 0) {
          _shop!.purchasedItemIds.add(updatedItem.id);
        }
        // Optionally update item in your shop list or Hive box here
      } else {
        _shop!.purchasedItemIds.add(item.id);
      }

      await _shopRepository.saveShop(_shop!);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Purchase failed: $e');
      // Refund on error
      totalCost.forEach((currency, amount) {
        final resource = _resourceRepository.getResourceByName(currency);
        if (resource != null) {
          resource.amount += amount;
          _resourceRepository.updateResource(resource);
        }
      });
      return false;
    }
  }

  Future<void> _handlePotionPurchase(ShopItem item, {int quantity = 1}) async {
    try {
      // Find the potion template from your database using item.itemId
      final potionTemplate = PotionDatabase.allPotions.firstWhere(
        (p) => p.id == item.itemId,
        orElse: () => throw Exception("Potion not found in database"),
      );

      // Create a new potion instance with the desired quantity
      final newPotion = potionTemplate.copyWith(
        quantity: quantity,
      );

      // Wrap the newPotion in a list, since the repository expects List<Potion>
      await _potionRepository.addPotionsToInventory([newPotion]);

      notifyListeners();
    } catch (e) {
      debugPrint('Error handling potion purchase: $e');
      rethrow;
    }
  }

  Future<void> _handleGirlPurchase(ShopItem item) async {
    GirlFarmer? girlTemplate;
    try {
      girlTemplate = girlsData.firstWhere((g) => g.id == item.itemId);
    } catch (e) {
      girlTemplate = null;
    }
    if (girlTemplate == null) return;

    final newGirl = GirlFarmer(
      id: generateUniqueId(),
      name: girlTemplate.name,
      level: girlTemplate.level,
      miningEfficiency: girlTemplate.miningEfficiency,
      rarity: girlTemplate.rarity,
      stars: girlTemplate.stars,
      image: girlTemplate.image,
      imageFace: girlTemplate.imageFace,
      attackPoints: girlTemplate.attackPoints,
      defensePoints: girlTemplate.defensePoints,
      agilityPoints: girlTemplate.agilityPoints,
      hp: girlTemplate.hp,
      mp: girlTemplate.mp,
      sp: girlTemplate.sp,
      maxHp: girlTemplate.hp,
      maxMp: girlTemplate.mp,
      maxSp: girlTemplate.sp,
      abilities:
          _initializeAbilities(girlTemplate.race, girlTemplate.abilities),
      race: girlTemplate.race,
      type: girlTemplate.type,
      region: girlTemplate.region,
      description: girlTemplate.description,
      criticalPoint: girlTemplate.criticalPoint,
      currentCooldowns: {},
      elementAffinities: girlTemplate.elementAffinities,
      statusEffects: [],
      partyMemberIds: [],
      equippedItems: [],
    );
    await _girlRepository.addGirl(newGirl);
  }

  Future<void> _handleEquipmentPurchase(ShopItem item) async {
    Equipment? equipTemplate;
    try {
      equipTemplate = equipmentList.firstWhere((e) => e.id == item.itemId);
    } catch (e) {
      equipTemplate = null;
    }
    if (equipTemplate == null) return;

    final newEquipment = Equipment(
      id: 'equip_${DateTime.now().millisecondsSinceEpoch}',
      name: equipTemplate.name,
      slot: equipTemplate.slot,
      rarity: equipTemplate.rarity,
      weaponType: equipTemplate.weaponType,
      armorType: equipTemplate.armorType,
      accessoryType: equipTemplate.accessoryType,
      attackBonus: equipTemplate.attackBonus,
      defenseBonus: equipTemplate.defenseBonus,
      hpBonus: equipTemplate.hpBonus,
      agilityBonus: equipTemplate.agilityBonus,
      enhancementLevel: 0,
      allowedTypes: List.from(equipTemplate.allowedTypes),
      allowedRaces: List.from(equipTemplate.allowedRaces),
      isTradable: equipTemplate.isTradable,
      mpBonus: equipTemplate.mpBonus,
      spBonus: equipTemplate.spBonus,
      criticalPoint: equipTemplate.criticalPoint,
    );
    await _equipmentRepository.addEquipment(newEquipment);
  }

  Future<void> _handleAbilityScrollPurchase(ShopItem item) async {
    AbilitiesModel? abilityTemplate;
    try {
      abilityTemplate =
          abilitiesList.firstWhere((a) => a.abilitiesID == item.itemId);
    } catch (e) {
      abilityTemplate = null;
    }
    if (abilityTemplate == null) return;

    final newAbility = AbilitiesModel(
      abilitiesID: 'ability_${DateTime.now().millisecondsSinceEpoch}',
      name: abilityTemplate.name,
      description: abilityTemplate.description,
      hpBonus: abilityTemplate.hpBonus,
      mpCost: abilityTemplate.mpCost,
      type: abilityTemplate.type,
      targetType: abilityTemplate.targetType,
      affectsEnemies: abilityTemplate.affectsEnemies,
      criticalPoint: abilityTemplate.criticalPoint,
    );
    await _abilityRepository.addAbility(newAbility);
  }

  bool canAfford(Map<String, int> prices) {
    return prices.entries.every((price) {
      final resource = _resourceRepository.getResourceByName(price.key);
      return resource != null && resource.amount >= price.value;
    });
  }

  void deductResources(Map<String, int> prices) {
    prices.forEach((currency, amount) {
      final resource = _resourceRepository.getResourceByName(currency);
      if (resource != null) {
        resource.amount -= amount;
        _resourceRepository.updateResource(resource);
      }
    });
    notifyListeners();
  }

  // Resource System ==========================================

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
  List<Potion> get potions => _potionRepository.getAllPotions();

  // ======================
  // Potion Management
  // ======================
  List<Potion> getFilteredPotions({
    PotionRarity? rarity,
    String? searchQuery,
  }) {
    return _potionRepository.getAllPotions().where((potion) {
      final matchesRarity = rarity == null || potion.rarity == rarity;
      final matchesSearch = searchQuery == null ||
          searchQuery.isEmpty ||
          potion.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          potion.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesRarity && matchesSearch;
    }).toList();
  }

  /// Uses a potion on a girl (with quantity support)
  Future<bool> usePotion({
    required String potionId,
    required String girlId,
    int quantity = 1,
  }) async {
    try {
      final potion = _potionRepository.getPotionById(potionId);
      final girl = _girlRepository.getGirlById(girlId);

      if (potion == null || girl == null) {
        throw Exception('Potion or girl not found');
      }

      if (!potion.canBeUsedBy(girl)) {
        throw Exception('${girl.name} cannot use this potion');
      }

      if (potion.quantity < quantity) {
        throw Exception(
            'Not enough ${potion.name} (${potion.quantity}/$quantity)');
      }

      // Apply effects for each potion used
      for (int i = 0; i < quantity; i++) {
        potion.applyPermanentEffects(girl);
      }

      // Update or remove potion based on remaining quantity
      if (potion.quantity > quantity) {
        final updatedPotion = potion.copyWith(
          quantity: potion.quantity - quantity,
        );
        await _potionRepository.updatePotion(updatedPotion);
      } else {
        await _potionRepository.deletePotion(potionId);
      }

      // Save changes to girl
      await _girlRepository.updateGirl(girl);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error using potion: $e');
      return false;
    }
  }

  /// Sells a potion for credits (with partial quantity support)
  Future<bool> sellPotion({
    required String potionId,
    int quantity = 1,
  }) async {
    try {
      final potion = _potionRepository.getPotionById(potionId);
      if (potion == null) return false;

      final credits = _resourceRepository.getResourceByName('Credits');
      if (credits == null) return false;

      if (potion.quantity < quantity) {
        throw Exception(
            'Not enough ${potion.name} to sell (${potion.quantity}/$quantity)');
      }

      final sellPrice = calculatePotionSellPrice(potion) * quantity;

      // Add credits
      credits.amount += sellPrice;
      await _resourceRepository.updateResource(credits);

      // Update or remove potion
      if (potion.quantity > quantity) {
        final updatedPotion = potion.copyWith(
          quantity: potion.quantity - quantity,
        );
        await _potionRepository.updatePotion(updatedPotion);
      } else {
        await _potionRepository.deletePotion(potionId);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error selling potion: $e');
      return false;
    }
  }

  /// Deletes a potion from inventory (with partial quantity support)
  Future<bool> deletePotion({
    required String potionId,
    required int quantity,
  }) async {
    try {
      final potion = _potionRepository.getPotionById(potionId);
      if (potion == null) return false;

      if (quantity <= 0) {
        throw Exception('Quantity must be greater than 0');
      }

      if (quantity >= potion.quantity) {
        // Delete entire stack if quantity >= current
        await _potionRepository.deletePotion(potionId);
      } else {
        // Reduce quantity if partial deletion
        final updatedPotion = potion.copyWith(
          quantity: potion.quantity - quantity,
        );
        await _potionRepository.updatePotion(updatedPotion);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting potion: $e');
      return false;
    }
  }

  /// Adds a potion to inventory (with stacking support)
  Future<void> addPotion(Potion potion) async {
    final existingPotion = _potionRepository.getPotionById(potion.id);

    if (existingPotion != null) {
      // Stack with existing potion
      final newQuantity = existingPotion.quantity + potion.quantity;
      final updatedPotion = existingPotion.copyWith(
        quantity: newQuantity.clamp(1, existingPotion.maxStack),
      );
      await _potionRepository.updatePotion(updatedPotion);
    } else {
      // Add new potion
      await _potionRepository.addPotion(potion);
    }
    notifyListeners();
  }

  /// Adds multiple potions to inventory (with stacking support)
  Future<void> addPotions(List<Potion> potions) async {
    for (final potion in potions) {
      await addPotion(potion);
    }
    notifyListeners();
  }

  /// Gets all girls that can use a specific potion
  List<GirlFarmer> getEligibleGirlsForPotion(Potion potion) {
    return _girlRepository
        .getAllGirls()
        .where((girl) => potion.canBeUsedBy(girl))
        .toList();
  }

  /// Calculates sell price based on potion rarity
  double calculatePotionSellPrice(Potion potion) {
    return switch (potion.rarity) {
      PotionRarity.common => 10,
      PotionRarity.uncommon => 25,
      PotionRarity.rare => 60,
      PotionRarity.epic => 150,
      PotionRarity.legendary => 400,
    };
  }

  /// Gets a potion by ID
  Potion? getPotionById(String id) {
    return _potionRepository.getPotionById(id);
  }

  /// Clears all potions from inventory (debug/reset)
  Future<void> clearAllPotions() async {
    await _potionRepository.clearAllPotions();
    notifyListeners();
  }

  /// Debug method to print all potions
  void debugPrintPotions() {
    _potionRepository.debugPrintPotions();
  }

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
  /// Check if an item can be equipped considering slot limitations
  bool canEquipItem(Equipment equipment, List<Equipment> currentlyEquipped) {
    // Check slot limitations
    switch (equipment.slot) {
      case EquipmentSlot.weapon:
        final weapons = currentlyEquipped
            .where((e) => e.slot == EquipmentSlot.weapon)
            .toList();

        if (weapons.length >= 2) return false;

        if (weapons.length == 1) {
          final existingWeapon = weapons.first;
          // Can't have two two-handed weapons
          if (existingWeapon.weaponType == WeaponType.twoHandedWeapon ||
              equipment.weaponType == WeaponType.twoHandedWeapon) {
            return false;
          }
          // Can't have two shields
          if (existingWeapon.weaponType == WeaponType.oneHandedShield &&
              equipment.weaponType == WeaponType.oneHandedShield) {
            return false;
          }
        }
        break;

      case EquipmentSlot.armor:
        final armors = currentlyEquipped
            .where((e) => e.slot == EquipmentSlot.armor)
            .toList();

        if (armors.length >= 2) return false;

        if (armors.length == 1) {
          // Can't have two of the same armor type
          if (armors.first.armorType == equipment.armorType) {
            return false;
          }
        }
        break;

      case EquipmentSlot.accessory:
        final accessories = currentlyEquipped
            .where((e) => e.slot == EquipmentSlot.accessory)
            .toList();

        if (accessories.length >= 3) return false;

        // Can't have more than one of the same accessory type
        if (accessories
            .any((a) => a.accessoryType == equipment.accessoryType)) {
          return false;
        }
        break;
    }

    return true;
  }

  /// Equip an item to a girl with slot limitation checks
  void equipToGirl(String equipmentId, String girlId) {
    final equipment = _equipmentRepository.getEquipmentById(equipmentId);
    final girl = _girlRepository.getGirlById(girlId);
    if (equipment == null) return;

    // Get all currently equipped items for this girl
    final currentEquipment =
        _equipmentRepository.getEquipmentByAssignedGirl(girlId);

    // Check if we can equip this item considering slot limitations
    if (!canEquipItem(equipment, currentEquipment)) {
      throw Exception('Cannot equip - slot limitations would be violated');
    }

    // Handle weapon slot limitations
    if (equipment.slot == EquipmentSlot.weapon) {
      final weapons = currentEquipment
          .where((e) => e.slot == EquipmentSlot.weapon)
          .toList();

      // If equipping a two-handed weapon, unequip all other weapons
      if (equipment.weaponType == WeaponType.twoHandedWeapon) {
        for (var weapon in weapons) {
          weapon.assignedTo = null;
          _equipmentRepository.updateEquipment(weapon);
        }
      }
      // If equipping a shield, unequip any other shield
      else if (equipment.weaponType == WeaponType.oneHandedShield) {
        final shields = weapons
            .where((w) => w.weaponType == WeaponType.oneHandedShield)
            .toList();
        for (var shield in shields) {
          shield.assignedTo = null;
          _equipmentRepository.updateEquipment(shield);
        }
      }
    }

    // Handle armor slot limitations
    if (equipment.slot == EquipmentSlot.armor) {
      final sameTypeArmor = currentEquipment
          .where((e) =>
              e.slot == EquipmentSlot.armor &&
              e.armorType == equipment.armorType)
          .toList();
      for (var armor in sameTypeArmor) {
        armor.assignedTo = null;
        _equipmentRepository.updateEquipment(armor);
      }
    }

    // Handle accessory slot limitations
    if (equipment.slot == EquipmentSlot.accessory) {
      final sameTypeAccessories = currentEquipment
          .where((e) =>
              e.slot == EquipmentSlot.accessory &&
              e.accessoryType == equipment.accessoryType)
          .toList();
      for (var accessory in sameTypeAccessories) {
        accessory.assignedTo = null;
        _equipmentRepository.updateEquipment(accessory);
      }
    }

    equipment.assignedTo = girlId;
    _equipmentRepository.updateEquipment(equipment);

    // Add this to update the girl's stats:
    girl?.equipItem(equipment);
    _girlRepository.updateGirl(girl!);

    notifyListeners();
  }

  void _updateGirlStats(String girlId) {
    final girl = _girlRepository.getGirlById(girlId);
    if (girl != null) {
      _girlRepository.updateGirl(girl);
      notifyListeners();
    }
  }

  /// Get equipment that can be equipped by a specific girl
  List<Equipment> getEquippableItemsForGirl(String girlId,
      {Equipment? currentItem}) {
    final girl = _girlRepository.getGirlById(girlId);
    if (girl == null) return [];

    final allEquipment = _equipmentRepository.getAllEquipment();
    final equippedItems = _equipmentRepository
        .getEquipmentByAssignedGirl(girlId)
        .where((e) => currentItem == null || e.id != currentItem.id)
        .toList();

    return allEquipment.where((equipment) {
      // Check type and race restrictions
      if (equipment.allowedTypes.isNotEmpty &&
          !equipment.allowedTypes.contains(girl.type)) {
        return false;
      }
      if (equipment.allowedRaces.isNotEmpty &&
          !equipment.allowedRaces.contains(girl.race)) {
        return false;
      }

      // Check slot limitations
      return canEquipItem(equipment, equippedItems);
    }).toList();
  }

  /// Unequip an item from any girl
  void unequipItem(String equipmentId) {
    final equipment = _equipmentRepository.getEquipmentById(equipmentId);
    if (equipment != null && equipment.assignedTo != null) {
      final girl = _girlRepository.getGirlById(equipment.assignedTo!);
      if (girl != null) {
        girl.unequipItem(equipment);
        _girlRepository.updateGirl(girl);
      }
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
          weaponType: equipment.weaponType,
          armorType: equipment.armorType,
          accessoryType: equipment.accessoryType,
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

// Helper method to create random equipment with proper types
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

      final now = DateTime.now().millisecondsSinceEpoch;
      final capitalizedRarity = _capitalize(rarity.name);

      return switch (slot) {
        EquipmentSlot.weapon => Equipment(
            id: '${rarity.name}_weapon_$now',
            name: '$capitalizedRarity ${_getRandomWeaponName(random)}',
            slot: slot,
            rarity: rarity,
            weaponType: _getRandomWeaponType(random),
            attackBonus: baseValue,
            defenseBonus: baseValue ~/ 4,
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
            name: '$capitalizedRarity ${_getRandomArmorName(random)}',
            slot: slot,
            rarity: rarity,
            armorType: _getRandomArmorType(random),
            defenseBonus: baseValue,
            hpBonus: baseValue ~/ 2,
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
            name: '$capitalizedRarity ${_getRandomAccessoryName(random)}',
            slot: slot,
            rarity: rarity,
            accessoryType: _getRandomAccessoryType(random),
            agilityBonus: baseValue,
            hpBonus: baseValue ~/ 3,
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

// Helper methods for random generation
  String _getRandomWeaponName(Random random) {
    final types = ['Sword', 'Axe', 'Mace', 'Dagger', 'Bow', 'Staff'];
    return types[random.nextInt(types.length)];
  }

  WeaponType _getRandomWeaponType(Random random) {
    return WeaponType.values[random.nextInt(WeaponType.values.length)];
  }

  String _getRandomArmorName(Random random) {
    final types = ['Plate', 'Mail', 'Leather', 'Robe', 'Cloak'];
    return types[random.nextInt(types.length)];
  }

  ArmorType _getRandomArmorType(Random random) {
    return ArmorType.values[random.nextInt(ArmorType.values.length)];
  }

  String _getRandomAccessoryName(Random random) {
    final types = ['Amulet', 'Ring', 'Bracelet', 'Talisman', 'Charm'];
    return types[random.nextInt(types.length)];
  }

  AccessoryType _getRandomAccessoryType(Random random) {
    return AccessoryType.values[random.nextInt(AccessoryType.values.length)];
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
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

  String _getSlotName(EquipmentSlot slot) {
    return switch (slot) {
      EquipmentSlot.weapon => 'Weapon',
      EquipmentSlot.armor => 'Armor',
      EquipmentSlot.accessory => 'Accessory',
    };
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
