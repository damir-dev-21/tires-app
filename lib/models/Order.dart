import 'dart:convert';

import 'package:tires_app/models/Product/Product.dart';

class Order {
  final int userId;
  final int number;
  final List<Product> products;
  final List<Product> addition_products;
  final double total;
  final String date;
  String status;
  String uuid_sale;
  bool is_not_confirm = false;

  Order(this.userId, this.number, this.products, this.addition_products,
      this.total, this.date, this.status, this.uuid_sale, this.is_not_confirm);

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'number': number,
      'products': products,
      'addition_products': addition_products,
      'total': total,
      'date': date,
      'status': status,
      'uuid_sale': uuid_sale,
      'is_not_confirm': is_not_confirm,
    };
  }

  List<Product> mapToList(Map<String, dynamic> items) {
    List<Product> products = [];
    items.forEach((key, value) {
      products.add(Product.fromJson(value));
    });
    return products;
  }

  factory Order.fromJson(Map<String, dynamic> jsonI) {
    List<Product> products = [];
    List<Product> addition_products = [];

    json
        .decode(jsonI['products'])
        .forEach((element) => products.add(Product.fromJson(element)));
    json
        .decode(jsonI['addition_order'])
        .forEach((element) => addition_products.add(Product.fromJson(element)));

    return Order(
        jsonI['userId'],
        jsonI['number'],
        products,
        addition_products,
        jsonI['total'],
        jsonI['date'],
        jsonI['status'],
        jsonI['uuid_sale'],
        jsonI['is_not_confirm'] == 0 ? false : true);
  }
}

enum StatusOrder {
  newOrder,
  onTheWay,
  refused,
  shipment,
  unconfirmed,
  confirmed
}
