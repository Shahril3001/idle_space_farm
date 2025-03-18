import 'package:hive/hive.dart';
import '../models/farm_model.dart';
import '../models/floor_model.dart';

class FarmRepository {
  final Box<dynamic> _box;

  FarmRepository(this._box);

  /// Add a farm to the box
  Future<void> addFarm(Farm farm) async {
    print("DEBUG: Farm added - ${farm.name}");
    await _box.put('farm_${farm.name}', farm);
  }

  /// Get all farms from the box
  List<Farm> getAllFarms() {
    final farms = _box.values.whereType<Farm>().toList();
    print("DEBUG: Retrieved farms count: ${farms.length}"); // Add this line
    return farms;
  }

  /// Get a farm by name
  Farm? getFarmByName(String name) {
    return _box.get('farm_$name');
  }

  /// Update a farm
  Future<void> updateFarm(Farm farm) async {
    await _box.put('farm_${farm.name}', farm);
  }

  /// Delete a farm by name
  Future<void> deleteFarm(String name) async {
    await _box.delete('farm_$name');
  }

  /// Clear all farms
  Future<void> clearAllFarms() async {
    await _box.clear();
  }

  /// Add a floor to a farm
  Future<void> addFloorToFarm(String farmName, Floor floor) async {
    final farm = getFarmByName(farmName);
    if (farm != null) {
      farm.floors.add(floor);
      await updateFarm(farm);
    }
  }

  /// Get all floors for a farm
  List<Floor> getFloorsForFarm(String farmName) {
    final farm = getFarmByName(farmName);
    return farm?.floors ?? [];
  }

  /// Update a floor in a farm
  Future<void> updateFloorInFarm(String farmName, Floor floor) async {
    final farm = getFarmByName(farmName);
    if (farm != null) {
      final index = farm.floors.indexWhere((f) => f.id == floor.id);
      if (index != -1) {
        farm.floors[index] = floor;
        await updateFarm(farm);
      }
    }
  }

  /// Delete a floor from a farm
  Future<void> deleteFloorFromFarm(String farmName, String floorId) async {
    final farm = getFarmByName(farmName);
    if (farm != null) {
      farm.floors.removeWhere((f) => f.id == floorId);
      await updateFarm(farm);
    }
  }

  /// Assign a girl farmer to a floor
  Future<void> assignGirlToFloor(
      String farmName, String floorId, String girlId) async {
    final farm = getFarmByName(farmName);
    if (farm != null) {
      final floor = farm.floors.firstWhere((f) => f.id == floorId);
      floor.assignedGirlId = girlId;
      await updateFarm(farm);
    }
  }

  /// Unassign a girl farmer from a floor
  Future<void> unassignGirlFromFloor(String farmName, String floorId) async {
    final farm = getFarmByName(farmName);
    if (farm != null) {
      final floor = farm.floors.firstWhere((f) => f.id == floorId);
      floor.assignedGirlId = null;
      await updateFarm(farm);
    }
  }

  /// Upgrade a floor
  Future<void> upgradeFloor(String farmName, String floorId) async {
    final farm = getFarmByName(farmName);
    if (farm != null) {
      final floor = farm.floors.firstWhere((f) => f.id == floorId);
      floor.level++;
      await updateFarm(farm);
    }
  }

  /// Unlock a floor
  Future<void> unlockFloor(String farmName, String floorId) async {
    final farm = getFarmByName(farmName);
    if (farm != null) {
      final floor = farm.floors.firstWhere((f) => f.id == floorId);
      floor.isUnlocked = true;
      await updateFarm(farm);
    }
  }
}
