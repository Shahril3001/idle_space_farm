import 'package:hive/hive.dart';
import '../models/girl_farmer_model.dart';

class GirlRepository {
  final Box<dynamic> _box;

  GirlRepository(this._box);

  Future<void> addGirl(GirlFarmer girl) async {
    await _box.put('girl_${girl.id}', girl);
    print('[REPO] Saved girl ${girl.name} to Hive');
  }

  List<GirlFarmer> getAllGirls() {
    return _box.values.whereType<GirlFarmer>().toList();
  }

  GirlFarmer? getGirlById(String id) {
    return _box.get('girl_$id');
  }

  Future<void> updateGirl(GirlFarmer girl) async {
    await _box.put('girl_${girl.id}', girl);
  }

  Future<void> deleteGirl(String id) async {
    await _box.delete('girl_$id');
  }

  Future<void> clearAllGirls() async {
    final girlKeys =
        _box.keys.where((key) => key.toString().startsWith('girl_'));
    await _box.deleteAll(girlKeys);
  }

  Future<void> saveAllGirls(List<GirlFarmer> girls) async {
    // Only add new girls without clearing existing ones
    for (final girl in girls) {
      if (!_box.containsKey('girl_${girl.id}')) {
        await addGirl(girl);
      }
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
