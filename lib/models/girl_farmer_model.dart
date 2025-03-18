import 'package:hive/hive.dart';

part 'girl_farmer_model.g.dart';

@HiveType(typeId: 2)
class GirlFarmer {
  @HiveField(0)
  String id; // Unique identifier

  @HiveField(1)
  String name;

  @HiveField(2)
  int level;

  @HiveField(3)
  double miningEfficiency;

  @HiveField(4)
  String? assignedFarm;

  @HiveField(5)
  String rarity; // Common, Rare, Unique

  @HiveField(6)
  int stars; // 1-6

  @HiveField(7)
  String image; // Path to the girl's image

  GirlFarmer({
    required this.id, // Make id required
    this.name = "",
    this.level = 1,
    this.miningEfficiency = 1.0,
    this.assignedFarm,
    required this.rarity,
    required this.stars,
    required this.image,
  });

  void upgrade() {
    level++;
    miningEfficiency *= 1.2;
  }
}
