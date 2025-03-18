import 'package:hive/hive.dart';

part 'floor_model.g.dart'; // Generated file

@HiveType(typeId: 4) // Use a unique typeId
class Floor {
  @HiveField(0)
  final String id;

  @HiveField(1)
  int level;

  @HiveField(2)
  bool isUnlocked;

  @HiveField(3)
  String? assignedGirlId;

  Floor({
    required this.id,
    this.level = 1,
    this.isUnlocked = false,
    this.assignedGirlId,
  });
}
