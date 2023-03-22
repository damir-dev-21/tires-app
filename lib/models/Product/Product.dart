import 'package:hive/hive.dart';

part 'Product.g.dart';

@HiveType(typeId: 5)
class Product {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String guid;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String image;
  @HiveField(4)
  final String category;
  @HiveField(5)
  final String groups;
  @HiveField(6)
  final String producer;
  @HiveField(7)
  final String typesize;
  @HiveField(8)
  final double price;
  @HiveField(9)
  final int count;
  @HiveField(10)
  double priority;
  @HiveField(11)
  int currentCount = 0;

  Product(
      this.id,
      this.guid,
      this.name,
      this.image,
      this.category,
      this.groups,
      this.producer,
      this.typesize,
      this.price,
      this.count,
      this.priority,
      this.currentCount);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guid': guid,
      'name': name,
      'image': image,
      'category': category,
      'groups': groups,
      'producer': producer,
      'typesize': typesize,
      'price': price,
      'count': count,
      'priority': priority,
      'currentCount': currentCount
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        json['id'] as int,
        json['guid'] as String,
        json['name'] as String,
        json['image'] as String,
        json['category'] as String,
        json['groups'] as String,
        json['producer'] as String,
        json['typesize'] as String,
        json['price'] as double,
        json['count'] as int,
        json['priority'] as double,
        json['currentCount'] as int);
  }
}
