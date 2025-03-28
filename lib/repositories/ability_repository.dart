import 'package:hive/hive.dart';
import '../models/ability_model.dart';

class AbilityRepository {
  final Box<dynamic> _box;

  AbilityRepository(this._box);

  /// Adds a new ability to the repository
  Future<void> addAbility(AbilitiesModel ability) async {
    await _box.put('ability_${ability.abilitiesID}', ability);
  }

  /// Retrieves all abilities from the repository
  List<AbilitiesModel> getAllAbilities() {
    return _box.values.whereType<AbilitiesModel>().toList();
  }

  /// Gets an ability by its ID
  AbilitiesModel? getAbilityById(String abilitiesID) {
    return _box.get('ability_$abilitiesID');
  }

  /// Updates an existing ability
  Future<void> updateAbility(AbilitiesModel ability) async {
    await _box.put('ability_${ability.abilitiesID}', ability);
  }

  /// Deletes an ability by its ID
  Future<void> deleteAbility(String abilitiesID) async {
    await _box.delete('ability_$abilitiesID');
  }

  /// Clears all abilities from the repository
  Future<void> clearAllAbilities() async {
    final abilities = getAllAbilities();
    for (var ability in abilities) {
      await deleteAbility(ability.abilitiesID);
    }
  }
}
