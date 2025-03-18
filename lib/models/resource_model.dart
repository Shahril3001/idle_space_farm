import 'package:hive/hive.dart';

part 'resource_model.g.dart';

@HiveType(typeId: 0)
class Resource {
  @HiveField(0)
  String name;

  @HiveField(1)
  double amount;

  Resource({required this.name, required this.amount});
}
