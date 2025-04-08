import 'package:hive/hive.dart';
import '../models/potion_model.dart';
import '../models/girl_farmer_model.dart';
import 'girl_repository.dart';

class PotionRepository {
  final Box<dynamic> _box;

  PotionRepository(this._box);

  Future<void> addPotion(Potion potion) async {
    await _box.put('potion_${potion.id}', potion);
    print('[PotionRepo] Saved potion ${potion.name} to Hive');
  }

  List<Potion> getAllPotions() {
    return _box.values.whereType<Potion>().toList();
  }

  Potion? getPotionById(String id) {
    return _box.get('potion_$id');
  }

  Future<void> updatePotion(Potion potion) async {
    await _box.put('potion_${potion.id}', potion);
  }

  Future<void> deletePotion(String id) async {
    await _box.delete('potion_$id');
  }

  Future<void> clearAllPotions() async {
    final potionKeys =
        _box.keys.where((key) => key.toString().startsWith('potion_'));
    await _box.deleteAll(potionKeys);
  }

  Future<void> saveAllPotions(List<Potion> potions) async {
    await clearAllPotions();
    for (final potion in potions) {
      await addPotion(potion);
    }
  }

  Future<void> addPotionsToInventory(List<Potion> potions) async {
    for (final potion in potions) {
      final existing = getPotionById(potion.id);
      if (existing != null) {
        // Create new instance with unique ID
        final newPotion = potion.copyWith(
            id: '${potion.id}_${DateTime.now().millisecondsSinceEpoch}');
        await addPotion(newPotion);
      } else {
        await addPotion(potion);
      }
    }
  }

  Future<void> usePotion({
    required String potionId,
    required GirlFarmer target,
    required GirlRepository girlRepo,
  }) async {
    final potion = getPotionById(potionId);
    if (potion == null) return;

    if (!potion.canBeUsedBy(target)) {
      print('${target.name} cannot use this potion');
      return;
    }

    // Apply effects
    potion.applyPermanentEffects(target);

    // Save changes
    await girlRepo.updateGirl(target);
    await deletePotion(potionId);

    print('${target.name} used ${potion.name}');
  }

  // Debug methods
  void debugPrintPotions() {
    print('=== Potions in Inventory ===');
    _box.values.whereType<Potion>().forEach((potion) {
      print('${potion.name} (${potion.id})');
      print('- Rarity: ${potion.rarity.name}');
      if (potion.hpIncrease > 0) print('- HP: +${potion.hpIncrease}');
      if (potion.attackIncrease > 0) print('- ATK: +${potion.attackIncrease}');
      // Add other stats as needed
    });
  }
}
