// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/constants/config.dart';
import 'package:tires_app/constants/images.dart';

import 'package:http/http.dart' as http;
import 'package:tires_app/models/Message.dart';
import 'package:tires_app/models/Product.dart';
import 'package:tires_app/models/Products/Products.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/services/database_helper.dart';

class ProductProvider extends ChangeNotifier {
  Box<Products> getProductsFromDb() => Hive.box<Products>('products');
  final DatabaseHelper _db = DatabaseHelper();
  List<Product> products = [];
  List<Map<String, dynamic>> productsForDb = [];
  final List<Product> newProducts = [];
  final List<Product> recomendation = [];
  late List<Product> filteredList = [];
  late List<String> categories = [];
  late List<String> producers = [];
  late List<String> typesizes = [];
  List<Product> searchList = [];
  late List<Message> list_of_messages = [];

  String dateForLastSync = '';
  bool isLoad = false;

  Future<void> getSynchronization(context) async {
    try {
      await getProducts();
      await getNotifications();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getNotifications() async {
    try {
      list_of_messages.clear();
      var lis_future = await _db.getImei();
      String imei = lis_future[0];
      final responce = await http.post(
        Uri.parse(urlNotifications),
        headers: {'Authorization': basicAuth_sklad!},
        body: jsonEncode({'mobile_uuid': imei}),
      );
      if (responce.statusCode == 200) {
        await _db.deleteMessages();

        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        extractedData['results'].forEach((e) async {
          var content;
          String message_text = "";
          String status = "";
          if (e['status'] == 'Поступление') {
            message_text = e['message'];
            status = 'Поступление';
            content = [];

            for (var jtem in e['goods']) {
              final idx = products
                  .indexWhere((element) => element.guid == jtem['guid']);
              if (idx != -1) {
                content.add(products[idx].toMap());
              }
            }
          } else if (e['status'] == 'Поступление_Под') {
            message_text = e['message'];
            content = [];
            status = 'Поступление_Подразделение';

            for (var jtem in e['goods']) {
              final idx = products
                  .indexWhere((element) => element.guid == jtem['guid']);
              if (idx != -1) {
                content.add(products[idx].toMap());
              }
            }
          } else if (e['status'] == 'Прайс лист') {
            content = e['content'];
            status = 'Прайс лист';
            message_text = e['message'];
          } else if (e['status'] == 'Поступление_Кас') {
            content = e['content'];
            status = 'Поступление_Касса';
            message_text = e['message'];
          } else {
            status = 'Заказ';
            Map<String, dynamic> order_from_db =
                await _db.selectOrder(e['uuid_order']);
            if (order_from_db['is_not_confirm'] == 1) {
              await _db.changeOrderIsNotConfirmed(e['uuid_order'], false);
            }
            await _db.changeOrderStatus(
                e['uuid_order'], e['status_order'], e['uuid_sale']);
            message_text = "Статус заказа изменен на " +
                _defineStatusOrder(e['status_order']);
          }

          Message message = Message(
              id: Random().nextInt(1000),
              text: message_text,
              content: content,
              status: status);
          await _db.insertMessage(
              {'id': Random().nextInt(1000), 'text': json.encode(e)});
          list_of_messages.add(message);
          list_of_messages
              .sort((a, b) => a.text.length.compareTo(b.text.length));
          notifyListeners();
        });
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future<void> getStatus(status) async {
    final productsDb = getProductsFromDb().get('1');

    if (productsDb != null && status == false) {
      productsDb.products.forEach((e) {
        products.add(Product.fromJson(e));
      });
      getNewProducts();
      getRecomendation();
      notifyListeners();
    } else {
      getProductsFromDb().delete('1');
      await getProducts();
    }
  }

  void checkNotifications() async {
    list_of_messages = await _db.getMessages(products);
    notifyListeners();
  }

  Future<void> getProducts() async {
    try {
      isLoad = true;
      notifyListeners();
      final responce = await http.get(Uri.parse(urlProducts),
          headers: {'Authorization': basicAuth_sklad!});
      if (responce.statusCode == 200) {
        products.clear();
        newProducts.clear();
        recomendation.clear();
        producers.clear();
        typesizes.clear();
        filteredList.clear();
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        products.clear();

        extractedData['results'].forEach((element) async {
          String image = '';
          Product product = Product(
              element['ID'],
              element['GUID'],
              element['Товар'].replaceAll(RegExp("\\s+"), " "),
              getPhotoCategory(element['ТипТовара']),
              element['ВидТовара'],
              element['ТипТовара'],
              element['Производитель'],
              element['Типоразмер'],
              double.parse(element['Цена'].toString()),
              element['Остаток'],
              3,
              0);

          if (product.name != '' && product.price != 0) {
            products.add(product);
            //productsForDb.add(product.toMap());
          }
          notifyListeners();
        });

        getNewProducts();
        getRecomendation();
        checkNotifications();

        dateForLastSync = DateFormat("dd.MM.yy HH:mm").format(DateTime.now());
        isLoad = false;
        notifyListeners();
      } else {
        isLoad = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      isLoad = false;
      notifyListeners();
      throw e;
    }
    //getProductsFromDb().put("1", Products(productsForDb));
    getAllFilters();
    notifyListeners();
  }

  void getNewProducts() {
    var index = 0;
    while (index < 20) {
      Random random = Random();
      int randomNumber = random.nextInt(products.length);
      if (products[randomNumber].count > 0) {
        newProducts.add(products[randomNumber]);
        index = index + 1;
      }
    }
    notifyListeners();
  }

  void getRecomendation() {
    var index = 0;
    while (index < 20) {
      Random random = Random();
      int randomNumber = random.nextInt(products.length);
      if (products[randomNumber].count > 0) {
        recomendation.add(products[randomNumber]);
        index = index + 1;
      }
    }
    notifyListeners();
  }

  void getAllFilters() {
    List<String> categoriesFinded = [];
    List<String> producersFinded = [];
    List<String> typesizeFinded = [];

    for (var element in products) {
      if (!categoriesFinded.contains(element.groups) && element.groups != '') {
        categoriesFinded.add(element.groups);
      }
      if (!producersFinded.contains(element.producer) &&
          element.producer != '') {
        producersFinded.add(element.producer);
      }
      if (!typesizeFinded.contains(element.typesize) &&
          element.typesize != '') {
        typesizeFinded.add(element.typesize);
      }
    }
    categories = categoriesFinded;
    producers = producersFinded;
    typesizes = typesizeFinded;
    notifyListeners();
  }

  void setFilter(
      [String category = '', String producer = '', String typesize = '']) {
    filteredList.clear();

    notifyListeners();
    final prod = products.where((element) {
      if (category != '' && producer == '' && typesize == '') {
        return element.category == category;
      }
      if (category == '' && producer != '' && typesize == '') {
        return element.producer == producer;
      }
      if (category == '' && producer == '' && typesize != '') {
        return element.typesize == typesize;
      }
      return element.category == category ||
          element.producer == producer ||
          element.typesize == typesize;
    }).toList();
    filteredList = prod;
    notifyListeners();
  }

  String _defineStatusOrder(String text) {
    if (text == 'onTheWay') {
      return 'В пути';
    } else if (text == 'shipment') {
      return 'Отгрузка';
    } else if (text == 'refused') {
      return 'Отклонено';
    } else {
      return 'Новый';
    }
  }

  String getPhotoCategory(String category) {
    switch (category) {
      case "Шины":
        return category1;
      case "Аккумуляторы":
        return category2;
      case "Диски":
        return category3;
      case "Камера":
        return category4;
      case "Масло моторное":
        return category5;
      case "Запчасти":
        return category6;
      case "Сельхозтехника":
        return category7;
      case "Хоз.товары":
        return category8;
      case "Электроды":
        return category9;
      default:
        return '';
    }
  }

  void clearAllCountItems() {
    for (var element in products) {
      element.currentCount = 0;
    }
    for (var element in searchList) {
      element.currentCount = 0;
    }
    for (var element in newProducts) {
      element.currentCount = 0;
    }
    for (var element in recomendation) {
      element.currentCount = 0;
    }
    notifyListeners();
  }
}
