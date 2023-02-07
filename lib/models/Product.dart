class Product {
  final int id;
  final String guid;
  final String name;
  final String image;
  final String category;
  final String groups;
  final String producer;
  final String typesize;
  final double price;
  final int count;
  double priority;
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
