import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:tires_app/models/Product/Product.dart';

class Message {
  final int id;
  final String text;
  final content;
  final String status;
  final String date;

  Message(
      {required this.id,
      required this.text,
      required this.content,
      required this.status,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'content': content,
      'status': status,
      'date': date
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['id'] as int,
        text: json['text'] as String,
        content: json['content'],
        status: json['status'] as String,
        date: json['date'] as String);
  }

  static Message setMessageFromMap(
      Map<String, dynamic> json_text, List<Product> products) {
    var responce = json.decode(json_text['text']);
    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    String dateOfMessage =
        DateFormat("yyyy-MM-dd").format(dateFormat.parse(responce['date']));

    String message_text = "";
    List list_of_goods = [];
    if (responce['status'] == 'Поступление') {
      message_text = responce['message'];
      for (var jtem in responce['goods']) {
        final idx =
            products.indexWhere((element) => element.guid == jtem['guid']);
        if (idx != -1) {
          list_of_goods.add(products[idx].toMap());
        }
      }
      Message newMessage = Message(
          id: Random().nextInt(1000),
          text: message_text,
          content: list_of_goods,
          status: "Поступление",
          date: dateOfMessage);
      return newMessage;
    } else if (responce['status'] == 'Поступление_Под') {
      message_text = responce['message'];
      for (var jtem in responce['goods']) {
        final idx =
            products.indexWhere((element) => element.guid == jtem['guid']);
        if (idx != -1) {
          list_of_goods.add(products[idx].toMap());
        }
      }
      Message newMessage = Message(
          id: Random().nextInt(1000),
          text: message_text,
          content: list_of_goods,
          status: "Поступление_Подразделение",
          date: dateOfMessage);
      return newMessage;
    } else if (responce['status'] == 'Прайс лист') {
      message_text = responce['message'];
      Message newMessage = Message(
          id: Random().nextInt(1000),
          text: message_text,
          content: responce['content'],
          status: "Прайс лист",
          date: dateOfMessage);
      return newMessage;
    } else if (responce['status'] == 'Акт сверки') {
      message_text = responce['message'];
      Message newMessage = Message(
          id: Random().nextInt(1000),
          text: message_text,
          content: responce['content'],
          status: "Акт сверки",
          date: dateOfMessage);
      return newMessage;
    } else if (responce['status'] == 'Поступление_Кас') {
      message_text = responce['message'];
      Message newMessage = Message(
          id: Random().nextInt(1000),
          text: message_text,
          content: responce['content'],
          status: "Поступление_Касса",
          date: dateOfMessage);
      return newMessage;
    } else {
      message_text = "Статус заказа изменен";
      var uuid_order = responce['uuid_order'];

      Message newMessage = Message(
          id: Random().nextInt(1000),
          text: responce['message'],
          content: uuid_order,
          status: "Заказ",
          date: dateOfMessage);
      return newMessage;
    }
  }
}
