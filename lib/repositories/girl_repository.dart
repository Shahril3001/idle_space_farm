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
    final girls = getAllGirls();
    for (var girl in girls) {
      await deleteGirl(girl.id);
    }
  }
}
