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
    // Delete all resource keys
    final resourceKeys =
        _box.keys.where((key) => key.toString().startsWith('resource_'));
    await _box.deleteAll(resourceKeys);
  }

  // Add this method to support the save/load system
  Future<void> saveAllResources(List<Resource> resources) async {
    await clearAllResources(); // Clear existing resources first
    for (final resource in resources) {
      await addResource(resource);
    }
  }
}
