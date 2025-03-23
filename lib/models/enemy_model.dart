import 'package:hive/hive.dart';

part 'enemy_model.g.dart'; // Generated file

@HiveType(typeId: 5) // Unique typeId for Hive
class Enemy {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  int level;
  @HiveField(3)
  int attackPoints;
  @HiveField(4)
  int defensePoints;
  @HiveField(5)
  int agilityPoints;
  @HiveField(6)
  int hp;
  @HiveField(7)
  int mp;
  @HiveField(8)
  int sp;
  @HiveField(9)
  final List<String> abilities;
  @HiveField(10)
  final String rarity;
  @HiveField(11)
  final String type;
  @HiveField(12)
  final String region;
  @HiveField(13)
  final String description;

  Enemy({
    required this.id,
    required this.name,
    required this.level,
    required this.attackPoints,
    required this.defensePoints,
    required this.agilityPoints,
    required this.hp,
    required this.mp,
    required this.sp,
    required this.abilities,
    required this.rarity,
    required this.type,
    required this.region,
    required this.description,
  });
}
