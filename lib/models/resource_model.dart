import 'package:hive/hive.dart';

part 'resource_model.g.dart';

@HiveType(typeId: 0)
class Resource {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  Resource({required this.name, required this.amount});

  // In Resource class
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
    };
  }

  factory Resource.fromMap(Map<String, dynamic> map) {
    return Resource(
      name: map['name'],
      amount: map['amount'],
    );
  }
}
