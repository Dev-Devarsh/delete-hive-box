import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'test_hive.g.dart';

@HiveType(typeId: 1, adapterName: 'HiveTestAdapter')
class HiveTest {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final int? age;
  HiveTest({required this.name, required this.age});
}
