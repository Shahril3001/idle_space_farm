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
}
