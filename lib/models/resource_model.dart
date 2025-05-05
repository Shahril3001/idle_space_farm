import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../data/resource_data.dart';

part 'resource_model.g.dart';

@HiveType(typeId: 0)
class Resource {
  @HiveField(0)
  final String name;

  @HiveField(1)
  double amount;

  Resource({
    required this.name,
    required this.amount,
  });

  // Presentation getters
  String get imagePath =>
      ResourceData.getConfig(name)?.imagePath ??
      'assets/images/resources/resources-default.png';

  Color get color => ResourceData.getConfig(name)?.color ?? Colors.grey;

  // Hive serialization
  Map<String, dynamic> toMap() => {
        'name': name,
        'amount': amount,
      };

  factory Resource.fromMap(Map<String, dynamic> map) {
    return Resource(
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
    );
  }

  Resource copyWith({double? amount}) {
    return Resource(
      name: name,
      amount: amount ?? this.amount,
    );
  }
}
