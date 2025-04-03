import 'package:hive/hive.dart';

part 'equipment_model.g.dart';

@HiveType(typeId: 3)
class Equipment {
  @HiveField(0)
  String name;

  @HiveField(1)
  String type; // Common or Special

  @HiveField(2)
  double statBoost; // Stat boost percentage

  Equipment({
    required this.name,
    required this.type,
    required this.statBoost,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'statBoost': statBoost,
    };
  }

  factory Equipment.fromMap(Map<String, dynamic> map) {
    return Equipment(
      name: map['name'] as String,
      type: map['type'] as String,
      statBoost: map['statBoost'] as double,
    );
  }
}
