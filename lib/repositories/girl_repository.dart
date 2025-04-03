import 'package:hive/hive.dart';
import '../models/girl_farmer_model.dart';

class GirlRepository {
  final Box<dynamic> _box;

  GirlRepository(this._box);

  // Add a girl to the box
  Future<void> addGirl(GirlFarmer girl) async {
    await _box.put('girl_${girl.id}', girl);
  }

  // Get all girls from the box
  List<GirlFarmer> getAllGirls() {
    return _box.values.whereType<GirlFarmer>().toList();
  }

  // Get a girl by ID
  GirlFarmer? getGirlById(String id) {
    return _box.get('girl_$id');
  }

  // Update a girl
  Future<void> updateGirl(GirlFarmer girl) async {
    await _box.put('girl_${girl.id}', girl);
  }

  // Delete a girl by ID
  Future<void> deleteGirl(String id) async {
    await _box.delete('girl_$id');
  }

  // Clear all girls from the box
  Future<void> clearAllGirls() async {
    final girlKeys =
        _box.keys.where((key) => key.toString().startsWith('girl_'));
    await _box.deleteAll(girlKeys); // More efficient bulk deletion
  }

  Future<void> saveAllGirls(List<GirlFarmer> girls) async {
    await clearAllGirls(); // Clear existing first
    for (final girl in girls) {
      await addGirl(girl);
    }
  }

  void debugPrintGirls() {
    print('Stored girls: ${_box.values.map((g) => g.name).join(', ')}');
    _box.values.forEach((girl) {
      print('${girl.name} abilities:');
      girl.abilities.forEach((a) => print('- ${a.name} (${a.targetType})'));
    });
  }
}
