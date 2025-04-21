import 'package:hive/hive.dart';
import '../models/daily_reward_model.dart';

class DailyRewardRepository {
  final Box<dynamic> _box; // Now using dynamic box

  DailyRewardRepository(this._box);

  // Prefix keys to avoid collisions
  String _getKey(int day) => 'daily_reward_$day';

  Future<List<DailyReward>> getAllRewards() async {
    try {
      return _box.keys
          .where((k) => k.toString().startsWith('daily_reward_'))
          .map((key) => _box.get(key) as DailyReward)
          .toList();
    } catch (e) {
      print('Error getting all rewards: $e');
      return [];
    }
  }

  Future<DailyReward?> getRewardByDay(int day) async {
    try {
      return _box.get(_getKey(day)) as DailyReward?;
    } catch (e) {
      print('Error getting reward by day: $e');
      return null;
    }
  }

  Future<void> saveReward(DailyReward reward) async {
    try {
      await _box.put(_getKey(reward.day), reward);
    } catch (e) {
      print('Error saving reward: $e');
      rethrow;
    }
  }

  Future<void> saveAllRewards(List<DailyReward> rewards) async {
    try {
      // Clear existing rewards first
      await _box.deleteAll(_box.keys
          .where((k) => k.toString().startsWith('daily_reward_'))
          .toList());
      // Save new ones
      await _box
          .putAll({for (final reward in rewards) _getKey(reward.day): reward});
    } catch (e) {
      print('Error saving all rewards: $e');
      rethrow;
    }
  }

  Future<void> clearAll() async {
    try {
      await _box.deleteAll(_box.keys
          .where((k) => k.toString().startsWith('daily_reward_'))
          .toList());
    } catch (e) {
      print('Error clearing rewards: $e');
      rethrow;
    }
  }
}
