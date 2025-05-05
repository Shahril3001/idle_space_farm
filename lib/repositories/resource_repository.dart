import 'package:hive/hive.dart';
import '../models/resource_model.dart';

class ResourceRepository {
  final Box<dynamic> _box;

  ResourceRepository(this._box);

  Future<void> addResource(Resource resource) async {
    await _box.put('resource_${resource.name}', resource);
  }

  List<Resource> getAllResources() {
    return _box.values.whereType<Resource>().toList();
  }

  Resource? getResourceByName(String name) {
    return _box.get('resource_$name');
  }

  Future<void> updateResource(Resource resource) async {
    await _box.put('resource_${resource.name}', resource);
  }

  Future<void> deleteResource(String name) async {
    await _box.delete('resource_$name');
  }

  Future<void> clearAllResources() async {
    final resourceKeys = _box.keys
        .where((key) => key.toString().startsWith('resource_'))
        .toList();
    await _box.deleteAll(resourceKeys);
  }

  Future<void> saveAllResources(List<Resource> resources) async {
    await clearAllResources();
    for (final resource in resources) {
      await addResource(resource);
    }
  }

  // New helper methods
  Future<void> initializeDefaultResources() async {
    if ((await _box.keys
        .where((k) => k.toString().startsWith('resource_'))
        .isEmpty)) {
      await _addDefaultResources();
    }
  }

  Future<void> _addDefaultResources() async {
    const defaultResources = {
      'Default': 0.0,
      'Gold': 10000000.0,
      'Silver': 0.0,
      'Metal': 10000000.0,
      'Rune': 10000000.0,
      'Skill Book': 10000000.0,
      'Awakening Shard': 10000000.0,
      'Enhancement Stone': 10000000.0,
      'Forge Material': 10000000.0,
      'Girl Scroll': 10000000.0,
      'Equipment Chest': 10000000.0,
      'Gem': 10000000.0,
      'Diamond': 10000000.0,
      'Stamina': 10000000.0,
      'Dungeon Key': 100.0,
      'Arena Ticket': 100.0,
      'Raid Ticket': 100.0,
    };

    for (final entry in defaultResources.entries) {
      await addResource(Resource(
        name: entry.key,
        amount: entry.value,
      ));
    }
  }
}
