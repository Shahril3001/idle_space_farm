import 'package:hive/hive.dart';

part 'daily_reward_model.g.dart';

@HiveType(typeId: 27)
class DailyReward {
  @HiveField(0)
  final int day;

  @HiveField(1)
  final String rewardType; // 'resource', 'equipment', 'potion'

  @HiveField(2)
  final String rewardId;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  bool isClaimed;

  @HiveField(5)
  DateTime? claimDate;

  @HiveField(6)
  int streak;

  DailyReward({
    required this.day,
    required this.rewardType,
    required this.rewardId,
    this.amount = 1,
    this.isClaimed = false,
    this.claimDate,
    this.streak = 0,
  });

  DailyReward copyWith({
    int? day,
    String? rewardType,
    String? rewardId,
    double? amount,
    bool? isClaimed,
    DateTime? claimDate,
    int? streak,
  }) {
    return DailyReward(
      day: day ?? this.day,
      rewardType: rewardType ?? this.rewardType,
      rewardId: rewardId ?? this.rewardId,
      amount: amount ?? this.amount,
      isClaimed: isClaimed ?? this.isClaimed,
      claimDate: claimDate ?? this.claimDate,
      streak: streak ?? this.streak,
    );
  }
}
