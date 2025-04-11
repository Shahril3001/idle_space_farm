import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/potion_model.dart';
import '../models/girl_farmer_model.dart';
import 'girl_repository.dart';

class PotionRepository {
  final Box<dynamic> _box;

  PotionRepository(this._box);

  // Basic CRUD operations
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

  // Modified to handle stacking
  Future<void> addPotionsToInventory(List<Potion> potionsToAdd) async {
    debugPrint('🧪 potionsToAdd runtimeType: ${potionsToAdd.runtimeType}');
    for (final potion in potionsToAdd) {
      debugPrint('🧪 Adding potion: ${potion.name}, qty: ${potion.quantity}');
      final existingPotion = getPotionById(potion.id);

      if (existingPotion != null) {
        debugPrint('🧪 Stacking with existing potion: ${existingPotion.name}');
        // Calculate new quantity without exceeding maxStack
        final newQuantity = existingPotion.quantity + potion.quantity;
        final clampedQuantity = newQuantity.clamp(1, existingPotion.maxStack);

        // Update existing potion with new quantity
        final updatedPotion = existingPotion.copyWith(
          quantity: clampedQuantity,
        );
        debugPrint(
            '🧪 Updating potion: ${updatedPotion.name} with qty $clampedQuantity');
        await updatePotion(updatedPotion);

        if (newQuantity > existingPotion.maxStack) {
          print(
              '${potion.name} reached max stack of ${existingPotion.maxStack}');
        }
      } else {
        // Add new potion to inventory
        debugPrint('🧪 Adding new potion to inventory');
        await addPotion(potion);
      }
    }
  }

  // Enhanced to handle partial usage (using some quantity)
  Future<void> usePotion({
    required String potionId,
    required GirlFarmer target,
    required GirlRepository girlRepo,
    int quantity = 1,
  }) async {
    final potion = getPotionById(potionId);
    if (potion == null) {
      print('Potion $potionId not found in inventory');
      return;
    }

    if (!potion.canBeUsedBy(target)) {
      print('${target.name} cannot use this potion');
      return;
    }

    if (potion.quantity < quantity) {
      print(
          'Not enough ${potion.name} in inventory (has ${potion.quantity}, needs $quantity)');
      return;
    }

    // Apply effects for each potion used
    for (int i = 0; i < quantity; i++) {
      potion.applyPermanentEffects(target);
    }

    // Update or remove potion based on remaining quantity
    if (potion.quantity > quantity) {
      final updatedPotion = potion.copyWith(
        quantity: potion.quantity - quantity,
      );
      await updatePotion(updatedPotion);
    } else {
      await deletePotion(potionId);
    }

    // Save changes to girl
    await girlRepo.updateGirl(target);

    print('${target.name} used $quantity ${potion.name}(s)');
  }

  // Debug methods
  void debugPrintPotions() {
    print('=== Potions in Inventory ===');
    final potions = getAllPotions();

    if (potions.isEmpty) {
      print('No potions in inventory');
      return;
    }

    for (final potion in potions) {
      print('${potion.name} (ID: ${potion.id})');
      print('- Quantity: ${potion.quantity}/${potion.maxStack}');
      print('- Rarity: ${potion.rarity.name}');
      if (potion.hpIncrease > 0) print('- HP: +${potion.hpIncrease}');
      if (potion.mpIncrease > 0) print('- MP: +${potion.mpIncrease}');
      if (potion.spIncrease > 0) print('- SP: +${potion.spIncrease}');
      if (potion.attackIncrease > 0) print('- ATK: +${potion.attackIncrease}');
      if (potion.defenseIncrease > 0)
        print('- DEF: +${potion.defenseIncrease}');
      if (potion.agilityIncrease > 0)
        print('- AGI: +${potion.agilityIncrease}');
      if (potion.criticalPointIncrease > 0)
        print('- CRIT: +${potion.criticalPointIncrease}');
      print('---');
    }
  }
}
