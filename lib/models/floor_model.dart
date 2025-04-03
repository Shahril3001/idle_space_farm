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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'isUnlocked': isUnlocked,
      'assignedGirlId': assignedGirlId,
    };
  }

  factory Floor.fromMap(Map<String, dynamic> map) {
    return Floor(
      id: map['id'] as String,
      level: map['level'] as int,
    )
      ..isUnlocked = map['isUnlocked'] as bool
      ..assignedGirlId = map['assignedGirlId'] as String?;
  }
}
