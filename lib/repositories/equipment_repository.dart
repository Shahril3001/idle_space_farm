import 'package:hive/hive.dart';
import '../models/equipment_model.dart';

class EquipmentRepository {
  final Box<dynamic> _box;

  EquipmentRepository(this._box);

  /// Add an equipment to the box
  Future<void> addEquipment(Equipment equipment) async {
    await _box.put('equipment_${equipment.id}', equipment);
  }

  /// Get all equipment from the box
  List<Equipment> getAllEquipment() {
    return _box.values.whereType<Equipment>().toList();
  }

  /// Get an equipment by ID
  Equipment? getEquipmentById(String id) {
    return _box.get('equipment_$id');
  }

  /// Get equipment by name (case insensitive)
  List<Equipment> getEquipmentByName(String name) {
    return _box.values
        .whereType<Equipment>()
        .where((equipment) =>
            equipment.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  /// Get equipment by rarity
  List<Equipment> getEquipmentByRarity(EquipmentRarity rarity) {
    return _box.values
        .whereType<Equipment>()
        .where((equipment) => equipment.rarity == rarity)
        .toList();
  }

  /// Get equipment by slot type
  List<Equipment> getEquipmentBySlot(EquipmentSlot slot) {
    return _box.values
        .whereType<Equipment>()
        .where((equipment) => equipment.slot == slot)
        .toList();
  }

  /// Get equipment assigned to a specific girl
  List<Equipment> getEquipmentByAssignedGirl(String girlId) {
    return _box.values
        .whereType<Equipment>()
        .where((equipment) => equipment.assignedTo == girlId)
        .toList();
  }

  /// Get unassigned equipment
  List<Equipment> getUnassignedEquipment() {
    return _box.values
        .whereType<Equipment>()
        .where((equipment) => equipment.assignedTo == null)
        .toList();
  }

  /// Update an equipment
  Future<void> updateEquipment(Equipment equipment) async {
    await _box.put('equipment_${equipment.id}', equipment);
  }

  /// Delete an equipment by ID
  Future<void> deleteEquipment(String id) async {
    await _box.delete('equipment_$id');
  }

  /// Clear all equipment
  Future<void> clearAllEquipment() async {
    final equipmentKeys = _box.keys
        .where((key) => key.toString().startsWith('equipment_'))
        .toList();
    await _box.deleteAll(equipmentKeys);
  }

  /// Save all equipment (overwrites existing)
  Future<void> saveAllEquipment(List<Equipment> equipment) async {
    await clearAllEquipment();
    for (final item in equipment) {
      await addEquipment(item);
    }
  }

  /// Get count of equipment by rarity
  Map<EquipmentRarity, int> getEquipmentCountByRarity() {
    final counts = <EquipmentRarity, int>{};
    for (var rarity in EquipmentRarity.values) {
      counts[rarity] = getEquipmentByRarity(rarity).length;
    }
    return counts;
  }

  /// Get filtered equipment
  List<Equipment> getFilteredEquipment({
    EquipmentRarity? rarity,
    EquipmentSlot? slot,
    String? searchTerm,
    bool? isAssigned,
    int? minEnhancementLevel,
    int? maxEnhancementLevel,
  }) {
    var equipment = _box.values.whereType<Equipment>().toList();

    if (rarity != null) {
      equipment = equipment.where((e) => e.rarity == rarity).toList();
    }

    if (slot != null) {
      equipment = equipment.where((e) => e.slot == slot).toList();
    }

    if (searchTerm != null && searchTerm.isNotEmpty) {
      equipment = equipment
          .where((e) => e.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    if (isAssigned != null) {
      equipment = equipment
          .where(
              (e) => isAssigned ? e.assignedTo != null : e.assignedTo == null)
          .toList();
    }

    if (minEnhancementLevel != null) {
      equipment = equipment
          .where((e) => e.enhancementLevel >= minEnhancementLevel)
          .toList();
    }

    if (maxEnhancementLevel != null) {
      equipment = equipment
          .where((e) => e.enhancementLevel <= maxEnhancementLevel)
          .toList();
    }

    return equipment;
  }
}
