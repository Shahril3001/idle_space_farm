import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'floor_model.dart'; // Import the Floor model

part 'farm_model.g.dart';

@HiveType(typeId: 1)
class Farm {
  @HiveField(0)
  String name;

  @HiveField(1)
  double resourcePerSecond;

  @HiveField(2)
  int level;

  @HiveField(3)
  double unlockCost;

  @HiveField(4)
  int maxLevel;

  @HiveField(5)
  String resourceType;

  @HiveField(6)
  double upgradeCost;

  @HiveField(7)
  List<Floor> floors;

  @HiveField(8)
  List<double> positionData; // Store position as a list of doubles

  Farm({
    required this.name,
    required this.resourcePerSecond,
    this.level = 1,
    required this.unlockCost,
    this.maxLevel = 30,
    required this.resourceType,
    required this.upgradeCost,
    List<Floor>? floors,
    Offset? position, // Make position optional
  })  : floors = floors ?? [],
        positionData = position != null
            ? [position.dx, position.dy]
            : [0.0, 0.0]; // Default position

  Offset get position => Offset(positionData[0], positionData[1]);

  double get totalResourceGain => resourcePerSecond * level;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'resourcePerSecond': resourcePerSecond,
      'unlockCost': unlockCost,
      'resourceType': resourceType,
      'upgradeCost': upgradeCost,
      'position': {'dx': position.dx, 'dy': position.dy},
      'floors': floors.map((floor) => floor.toMap()).toList(),
    };
  }

  factory Farm.fromMap(Map<String, dynamic> map) {
    return Farm(
      name: map['name'] as String,
      resourcePerSecond: map['resourcePerSecond'] as double,
      unlockCost: map['unlockCost'] as double,
      resourceType: map['resourceType'] as String,
      upgradeCost: map['upgradeCost'] as double,
      position: Offset(
        (map['position'] as Map<String, dynamic>)['dx'] as double,
        (map['position'] as Map<String, dynamic>)['dy'] as double,
      ),
      floors: (map['floors'] as List)
          .map((f) => Floor.fromMap(f as Map<String, dynamic>))
          .toList(),
    );
  }
}
