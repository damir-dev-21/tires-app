import 'package:hive/hive.dart';
import 'package:tires_app/models/Order.dart';

part 'Orders.g.dart';

@HiveType(typeId: 2)
class Orders extends HiveObject {
  @HiveField(0)
  late List<Map<String, dynamic>> orders;

  Orders(this.orders);
}
