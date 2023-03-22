import 'package:hive/hive.dart';
import 'package:tires_app/models/Product/Product.dart';

part 'Products.g.dart';

@HiveType(typeId: 1)
class Products extends HiveObject {
  @HiveField(0)
  late List<Map<String, dynamic>> products;

  Products(this.products);
}
