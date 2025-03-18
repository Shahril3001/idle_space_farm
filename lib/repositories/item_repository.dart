import 'package:hive/hive.dart';
import '../models/equipment_model.dart';

class EquipmentRepository {
  final Box<dynamic> _box;

  EquipmentRepository(this._box);

  // Add an equipment to the box
  Future<void> addEquipment(Equipment equipment) async {
    await _box.put('equipment_${equipment.name}', equipment);
  }

  // Get all equipment from the box
  List<Equipment> getAllEquipment() {
    return _box.values.whereType<Equipment>().toList();
  }

  // Get an equipment by name
  Equipment? getEquipmentByName(String name) {
    return _box.get('equipment_$name');
  }

  // Update an equipment
  Future<void> updateEquipment(Equipment equipment) async {
    await _box.put('equipment_${equipment.name}', equipment);
  }

  // Delete an equipment by name
  Future<void> deleteEquipment(String name) async {
    await _box.delete('equipment_$name');
  }

  // Clear all equipment
  Future<void> clearAllEquipment() async {
    final equipment = getAllEquipment();
    for (var item in equipment) {
      await deleteEquipment(item.name);
    }
  }
}
