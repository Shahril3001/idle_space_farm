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
}
