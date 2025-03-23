import 'package:hive/hive.dart';
import '../models/enemy_model.dart';
import '../data/enemy_data.dart'; // Import the enemy_data.dart file

class EnemyRepository {
  final Box<dynamic> _box;

  EnemyRepository(this._box);

  /// Add an enemy to the box
  Future<void> addEnemy(Enemy enemy) async {
    await _box.put('enemy_${enemy.id}', enemy);
  }

  /// Get all enemies from the box
  List<Enemy> getAllEnemies() {
    return _box.values.whereType<Enemy>().toList();
  }

  /// Get an enemy by ID
  Enemy? getEnemyById(String id) {
    return _box.get('enemy_$id');
  }

  /// Update an enemy
  Future<void> updateEnemy(Enemy enemy) async {
    await _box.put('enemy_${enemy.id}', enemy);
  }

  /// Delete an enemy by ID
  Future<void> deleteEnemy(String id) async {
    await _box.delete('enemy_$id');
  }

  /// Clear all enemies from the box
  Future<void> clearAllEnemies() async {
    final enemies = getAllEnemies();
    for (var enemy in enemies) {
      await deleteEnemy(enemy.id);
    }
  }
}
