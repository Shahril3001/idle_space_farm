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
}