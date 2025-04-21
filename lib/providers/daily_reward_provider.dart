import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/daily_reward_model.dart';
import '../models/resource_model.dart';
import '../models/equipment_model.dart';
import '../models/potion_model.dart';
import '../repositories/dailyreward_repository.dart';
import '../repositories/resource_repository.dart';
import '../repositories/equipment_repository.dart';
import '../repositories/potion_repository.dart';
import '../data/equipment_data.dart';
import '../data/potion_data.dart';

class DailyRewardProvider {
  final DailyRewardRepository _rewardRepo;
  final ResourceRepository _resourceRepo;
  final EquipmentRepository _equipmentRepo;
  final PotionRepository _potionRepo;

  static late tz.Location _timezoneLocation;

  DailyRewardProvider({
    required DailyRewardRepository rewardRepo,
    required ResourceRepository resourceRepo,
    required EquipmentRepository equipmentRepo,
    required PotionRepository potionRepo,
  })  : _rewardRepo = rewardRepo,
        _resourceRepo = resourceRepo,
        _equipmentRepo = equipmentRepo,
        _potionRepo = potionRepo {
    _initializeTimezone();
  }

  void _initializeTimezone() {
    tz.initializeTimeZones();
    _timezoneLocation = tz.getLocation('Asia/Singapore');
  }

  tz.TZDateTime get _now => tz.TZDateTime.now(_timezoneLocation);

  Future<void> initializeDailyRewards() async {
    final rewards = await _rewardRepo.getAllRewards();
    if (rewards.isEmpty) {
      final defaultRewards = [
        DailyReward(
            day: 1, rewardType: 'resource', rewardId: 'Credits', amount: 100),
        DailyReward(
            day: 2,
            rewardType: 'equipment',
            rewardId: 'wpn_001'), // Rusty Sword
        DailyReward(
            day: 3, rewardType: 'resource', rewardId: 'Minerals', amount: 250),
        DailyReward(
            day: 4,
            rewardType: 'potion',
            rewardId: 'potion_hp_common'), // Minor Vitality Tonic
        DailyReward(
            day: 5, rewardType: 'resource', rewardId: 'Energy', amount: 250),
        DailyReward(
            day: 6,
            rewardType: 'equipment',
            rewardId: 'acc_001'), // Copper Ring
        DailyReward(
            day: 7,
            rewardType: 'potion',
            rewardId: 'potion_mp_common'), // Minor Mana Solution
      ];

      await _rewardRepo.saveAllRewards(defaultRewards);
    }
  }

  Future<bool> canClaimReward() async {
    final lastClaim = await _getLastClaimDate();
    final now = _now;

    // First-time user - can always claim
    if (lastClaim == null) {
      return true;
    }

    final lastClaimDate = tz.TZDateTime.from(lastClaim, _timezoneLocation);

    // Check if it's been more than 48 hours (break streak)
    final isStreakBroken = now.difference(lastClaimDate).inHours > 48;
    if (isStreakBroken) {
      return false;
    }

    // Normal case - check if it's a new day (after 4am)
    final isNewDay = _isNewDay(now, lastClaimDate);
    return isNewDay;
  }

  bool _isNewDay(tz.TZDateTime now, tz.TZDateTime lastClaimDate) {
    // If different calendar days
    if (now.day != lastClaimDate.day ||
        now.month != lastClaimDate.month ||
        now.year != lastClaimDate.year) {
      // For day change, check if current time is after 4am
      return now.hour >= 8;
    }
    return false;
  }

  Future<DailyReward?> getTodaysDailyReward() async {
    final streak = await getCurrentStreak();
    final now = _now;
    final lastClaim = await _getLastClaimDate();

    // If no last claim, return day 1
    if (lastClaim == null) {
      final rewards = await _rewardRepo.getAllRewards();
      return rewards.firstWhere((r) => r.day == 1);
    }

    final lastClaimDate = tz.TZDateTime.from(lastClaim, _timezoneLocation);

    // Only move to next reward if it's a new calendar day
    final isNewCalendarDay = now.day != lastClaimDate.day ||
        now.month != lastClaimDate.month ||
        now.year != lastClaimDate.year;

    final nextDay = !isNewCalendarDay ? streak : (streak == 7 ? 1 : streak + 1);

    final rewards = await _rewardRepo.getAllRewards();
    try {
      return rewards.firstWhere(
        (reward) => reward.day == nextDay,
        orElse: () => rewards.firstWhere((reward) => reward.day == 1),
      );
    } catch (e) {
      return null;
    }
  }

  Future<int> getCurrentStreak() async {
    final lastClaim = await _getLastClaimDate();
    if (lastClaim == null) return 0;

    final now = _now;
    final lastClaimDate = tz.TZDateTime.from(lastClaim, _timezoneLocation);

    // Streak broken if >48 hours
    if (now.difference(lastClaimDate).inHours > 48) {
      return 0;
    }

    // Get the last claimed reward's streak count
    final rewards = await _rewardRepo.getAllRewards();
    final claimedRewards = rewards.where((r) => r.claimDate != null).toList();

    if (claimedRewards.isEmpty) return 0;

    return claimedRewards.last.streak;
  }

  Future<DailyReward?> getTodaysReward() async {
    final streak = await getCurrentStreak();
    final nextDay = streak == 7 ? 1 : streak + 1;

    final rewards = await _rewardRepo.getAllRewards();
    try {
      return rewards.firstWhere(
        (reward) => reward.day == nextDay,
        orElse: () => rewards.firstWhere((reward) => reward.day == 1),
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> claimReward() async {
    final currentStreak = await getCurrentStreak();
    final nextDay = currentStreak == 7 ? 1 : currentStreak + 1;

    final rewards = await _rewardRepo.getAllRewards();
    final reward = rewards.firstWhere(
      (r) => r.day == nextDay,
      orElse: () => rewards.firstWhere((r) => r.day == 1),
    );

    // Check if already claimed today
    if (reward.isClaimed &&
        _isSameDay(
            _now, tz.TZDateTime.from(reward.claimDate!, _timezoneLocation))) {
      return false;
    }

    bool success = false;
    switch (reward.rewardType) {
      case 'resource':
        success = _claimResourceReward(reward);
        break;
      case 'equipment':
        success = _claimEquipmentReward(reward);
        break;
      case 'potion':
        success = _claimPotionReward(reward);
        break;
    }

    if (success) {
      final updatedReward = reward.copyWith(
        isClaimed: true,
        claimDate: DateTime.now(),
        streak: nextDay,
      );
      await _rewardRepo.saveReward(updatedReward);
      return true;
    }

    return false;
  }

  bool _isSameDay(tz.TZDateTime a, tz.TZDateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _claimResourceReward(DailyReward reward) {
    final resource = _resourceRepo.getResourceByName(reward.rewardId);
    if (resource != null) {
      resource.amount += reward.amount;
      _resourceRepo.updateResource(resource);
      return true;
    }
    return false;
  }

  bool _claimEquipmentReward(DailyReward reward) {
    final equipment = equipmentList.firstWhere(
      (e) => e.id == reward.rewardId,
      orElse: () => throw Exception('Equipment not found'),
    );

    final newEquipment = Equipment(
      id: '${equipment.id}_${DateTime.now().millisecondsSinceEpoch}',
      name: equipment.name,
      slot: equipment.slot,
      rarity: equipment.rarity,
      weaponType: equipment.weaponType,
      armorType: equipment.armorType,
      accessoryType: equipment.accessoryType,
      attackBonus: equipment.attackBonus,
      defenseBonus: equipment.defenseBonus,
      hpBonus: equipment.hpBonus,
      agilityBonus: equipment.agilityBonus,
      allowedTypes: List.from(equipment.allowedTypes),
      allowedRaces: List.from(equipment.allowedRaces),
      isTradable: equipment.isTradable,
      mpBonus: equipment.mpBonus,
      spBonus: equipment.spBonus,
      criticalPoint: equipment.criticalPoint,
    );

    _equipmentRepo.addEquipment(newEquipment);
    return true;
  }

  bool _claimPotionReward(DailyReward reward) {
    final potion = PotionDatabase.getPotion(reward.rewardId);
    if (potion == null) return false;

    final newPotion = potion.copyWith(
      quantity: reward.amount.toInt(),
    );

    _potionRepo.addPotionsToInventory([newPotion]);
    return true;
  }

  Future<DateTime?> _getLastClaimDate() async {
    final rewards = await _rewardRepo.getAllRewards();
    final claimedRewards =
        rewards.where((reward) => reward.claimDate != null).toList();

    if (claimedRewards.isEmpty) return null;

    claimedRewards.sort((a, b) => b.claimDate!.compareTo(a.claimDate!));
    return claimedRewards.first.claimDate;
  }

  Future<List<DailyReward>> getAllRewards() async {
    return await _rewardRepo.getAllRewards();
  }

  Future<void> resetRewards() async {
    await _rewardRepo.clearAll();
    await initializeDailyRewards();
  }
}
