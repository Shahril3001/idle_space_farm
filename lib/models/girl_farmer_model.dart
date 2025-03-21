import 'package:hive/hive.dart';
import 'equipment_model.dart';

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

  @HiveField(8)
  int attackPoints;

  @HiveField(9)
  int defensePoints;

  @HiveField(10)
  int agilityPoints;

  @HiveField(11)
  int hp;

  @HiveField(12)
  int mp;

  @HiveField(13)
  int sp;

  @HiveField(14)
  List<String> abilities; // List of skills/abilities

  @HiveField(15)
  String race; // Human, Elf, Demon, etc.

  @HiveField(16)
  String type; // Warrior, Mage, Assassin, etc.

  @HiveField(17)
  String region; // East, West, North, etc.

  @HiveField(18)
  String description; // Detailed character description

  GirlFarmer(
      {required this.id,
      this.name = "",
      this.level = 1,
      this.miningEfficiency = 1.0,
      this.assignedFarm,
      required this.rarity,
      required this.stars,
      required this.image,
      this.attackPoints = 10,
      this.defensePoints = 5,
      this.agilityPoints = 7,
      this.hp = 100,
      this.mp = 50,
      this.sp = 30,
      this.abilities = const [],
      required this.race,
      required this.type,
      required this.region,
      this.description =
          "A skilled farmer with a strong connection to the land."});

  void upgrade() {
    level++;
    miningEfficiency *= 1.2;
    attackPoints += 2;
    defensePoints += 2;
    agilityPoints += 1;
    hp += 20;
    mp += 10;
    sp += 5;
  }
}
