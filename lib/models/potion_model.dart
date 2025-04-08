import 'package:hive/hive.dart';
import 'girl_farmer_model.dart';
part 'potion_model.g.dart';

@HiveType(typeId: 21)
class Potion {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String
      iconAsset; // Path to image asset like 'assets/potions/health.png'

  @HiveField(4)
  final int maxStack;

  // Permanent stat increases
  @HiveField(5)
  final int hpIncrease;

  @HiveField(6)
  final int mpIncrease;

  @HiveField(7)
  final int spIncrease;

  @HiveField(8)
  final int attackIncrease;

  @HiveField(9)
  final int defenseIncrease;

  @HiveField(10)
  final int agilityIncrease;

  @HiveField(11)
  final int criticalPointIncrease;

  @HiveField(12)
  final PotionRarity rarity;

  @HiveField(13)
  final List<String> allowedTypes; // Which character types can use this

  Potion({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    this.maxStack = 99,
    this.hpIncrease = 0,
    this.mpIncrease = 0,
    this.spIncrease = 0,
    this.attackIncrease = 0,
    this.defenseIncrease = 0,
    this.agilityIncrease = 0,
    this.criticalPointIncrease = 0,
    this.rarity = PotionRarity.common,
    this.allowedTypes = const [], // Empty means all can use
  });

  Potion copyWith({
    String? id,
    String? name,
    String? description,
    String? iconAsset,
    int? maxStack,
    int? hpIncrease,
    int? mpIncrease,
    int? spIncrease,
    int? attackIncrease,
    int? defenseIncrease,
    int? agilityIncrease,
    int? criticalPointIncrease,
    PotionRarity? rarity,
    List<String>? allowedTypes,
  }) {
    return Potion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconAsset: iconAsset ?? this.iconAsset,
      maxStack: maxStack ?? this.maxStack,
      hpIncrease: hpIncrease ?? this.hpIncrease,
      mpIncrease: mpIncrease ?? this.mpIncrease,
      spIncrease: spIncrease ?? this.spIncrease,
      attackIncrease: attackIncrease ?? this.attackIncrease,
      defenseIncrease: defenseIncrease ?? this.defenseIncrease,
      agilityIncrease: agilityIncrease ?? this.agilityIncrease,
      criticalPointIncrease:
          criticalPointIncrease ?? this.criticalPointIncrease,
      rarity: rarity ?? this.rarity,
      allowedTypes: allowedTypes ?? this.allowedTypes,
    );
  }

  bool canBeUsedBy(GirlFarmer girl) {
    return allowedTypes.isEmpty || allowedTypes.contains(girl.type);
  }

  void applyPermanentEffects(GirlFarmer girl) {
    girl.maxHp += hpIncrease;
    girl.hp += hpIncrease;
    girl.maxMp += mpIncrease;
    girl.mp += mpIncrease;
    girl.maxSp += spIncrease;
    girl.sp += spIncrease;
    girl.attackPoints += attackIncrease;
    girl.defensePoints += defenseIncrease;
    girl.agilityPoints += agilityIncrease;
    girl.criticalPoint += criticalPointIncrease;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconAsset': iconAsset,
      'maxStack': maxStack,
      'hpIncrease': hpIncrease,
      'mpIncrease': mpIncrease,
      'spIncrease': spIncrease,
      'attackIncrease': attackIncrease,
      'defenseIncrease': defenseIncrease,
      'agilityIncrease': agilityIncrease,
      'criticalPointIncrease': criticalPointIncrease,
      'rarity': rarity.index,
      'allowedTypes': allowedTypes,
    };
  }

  factory Potion.fromMap(Map<String, dynamic> map) {
    return Potion(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      iconAsset: map['iconAsset'],
      maxStack: map['maxStack'],
      hpIncrease: map['hpIncrease'],
      mpIncrease: map['mpIncrease'],
      spIncrease: map['spIncrease'],
      attackIncrease: map['attackIncrease'],
      defenseIncrease: map['defenseIncrease'],
      agilityIncrease: map['agilityIncrease'],
      criticalPointIncrease: map['criticalPointIncrease'],
      rarity: PotionRarity.values[map['rarity']],
      allowedTypes: List<String>.from(map['allowedTypes']),
    );
  }
}

@HiveType(typeId: 22)
enum PotionRarity {
  @HiveField(0)
  common,
  @HiveField(1)
  uncommon,
  @HiveField(2)
  rare,
  @HiveField(3)
  epic,
  @HiveField(4)
  legendary,
}
