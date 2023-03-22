import 'package:hive/hive.dart';
import 'package:tires_app/models/Product/Product.dart';

part 'Cart.g.dart';

@HiveType(typeId: 4)
class Cart extends HiveObject {
  @HiveField(0)
  List<Product> cart = [];

  Cart(this.cart);
}
