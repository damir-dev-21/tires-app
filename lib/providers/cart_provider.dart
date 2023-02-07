// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
// import 'dart:ffi';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tires_app/models/Order.dart';
import 'package:tires_app/models/Orders/Orders.dart';
import 'package:tires_app/models/Product.dart';
import 'package:http/http.dart' as http;
import 'package:tires_app/models/User/User.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/services/background_fetch.dart';
import 'package:tires_app/services/database_helper.dart';
import 'package:tires_app/widgets/notifications.dart';

import '../constants/colors.dart';
import '../constants/config.dart';

ProductProvider productProvider = ProductProvider();

class CartProvider extends ChangeNotifier {
  DatabaseHelper _db = DatabaseHelper();
  Box<Orders> getOrdersFromDb() => Hive.box<Orders>('orders');
  List<Product> cart = [];
  final List<Product> additional_cart = [];
  List<Order> orders = [];
  List<Map<String, dynamic>> popular_answer = [];
  List<Map<String, dynamic>> imperfective_answer = [];
  List<Map<String, dynamic>> remainders_answer = [];
  String imperfective_text = "";
  bool isLoad = false;
  bool haslimit = false;
  var client = {};
  String balance = "0";
  int course_rate = 0;
  double total = 0;
  double total_additional = 0;
  double total_count = 0;
  double total_count_additional = 0;
  bool _isTrustPayment = false;
  double _trustPaymentAmount = 0.0;
  int _trustPaymentPeriod = 1;

  Future<void> checkOrders() async {
    var order_box = await _db.getOrders();

    if (order_box != null) {
      orders.clear();
      order_box.forEach((element) {
        orders.add(element);
      });
    }
    notifyListeners();
  }

  void addToCart(Product item) {
    final findProduct = cart.firstWhere((element) => element.id == item.id,
        orElse: () => Product(0, "", "", "", "", "", "", "", 0, 0, 0, 0));
    if (findProduct.id == 0) {
      cart.add(item);
    }
    changeTotalPrice();
    notifyListeners();
  }

  void addToAdditionalCart(Product item) {
    final findProduct = additional_cart.firstWhere(
        (element) => element.id == item.id,
        orElse: () => Product(0, "", "", "", "", "", "", "", 0, 0, 0, 0));
    if (findProduct.id == 0) {
      additional_cart.add(item);
    }
    changeTotalPriceAdditionalCart();
    notifyListeners();
  }

  Future<bool> checkOrder(BuildContext context, List<Product> products,
      AuthProvider auth_provider) async {
    orders.forEach((element) {
      if (element.status != StatusOrder.confirmed.name) {
        DateTime date_order = DateFormat("dd.MM.yy HH:mm").parse(element.date);
        DateTime date_order_future = date_order.add(const Duration(days: 1));
        DateTime date_current = DateFormat("dd.MM.yy HH:mm")
            .parse(DateFormat("dd.MM.yy HH:mm").format(DateTime.now()));

        if (date_current.day > date_order_future.day &&
            date_current.month >= date_order_future.month &&
            date_current.year >= date_order_future.year &&
            date_current.hour >= date_order_future.hour &&
            date_current.minute >= date_order_future.minute) {
          context.read<AuthProvider>().showAlert(
              context,
              "Есть не подтвержденные заказы, пожалуйста подтвердите заказы",
              AlertType.info);
          return;
        }
      }
    });

    final Map<String, dynamic> order =
        _createOrderForRequest(context, auth_provider.user);
    final User user = auth_provider.user;
    if (user.addition && additional_cart.isEmpty && total_count > 40) {
      try {
        auth_provider.showAlert(context, "Заполните доп заказ", AlertType.info);
        return true;
      } catch (e) {
        print(e);
        // context
        //     .read<AuthProvider>()
        //     .showAlert(context, "Заполните доп заказ", AlertType.info);
        // return true;
      }
    }

    if (user.addition) {
      var five_percentage_count = ((total_count * 5) / 100).round();
      if (total_count_additional > five_percentage_count) {
        auth_provider.showAlert(
            context,
            "Общее количество доп. заказов не больше 5% от общего количества заказов.",
            AlertType.info);

        return true;
      }
    }

    try {
      if (client.isEmpty) {
        await showAllClient(context);
      }

      String messageFromBack = '';
      isLoad = true;

      final responce = await http.post(Uri.parse(urlOrderCheck),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode(order));
      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;

        // results_remainder -> Остаток товаров
        // results_running -> Ходовые товары
        // results -> Нагрузочные товары

        // Check items on remainder, running and load
        _checkItemsFromResponce(extractedData, products);

        // Check limit if it has
        if (extractedData['message_limit'] != null) {
          messageFromBack = extractedData['message_limit'];
        } else {
          messageFromBack = extractedData['message'];
        }

        print(extractedData);
        print(popular_answer);
        print(remainders_answer);
        print(imperfective_answer);
        notifyListeners();

        // if responce is everything if fine...
        if (popular_answer.isEmpty &&
            imperfective_answer.isEmpty &&
            remainders_answer.isEmpty &&
            extractedData['limit_bool'] == false) {
          await checkBalanceAndConfidence(context, user);
          // await sendOrder(context, user);

          return true;
        }

        // Check limit from responce
        if (extractedData['limit_bool'] == true) {
          _showCheckBalanceAndTrustPaymentDialog(
              context, user, messageFromBack);
          //_showAlert(context, messageFromBack, AlertType.info);
          haslimit = true;
        }
        isLoad = false;

        notifyListeners();
        return false;
      } else {
        _showAlert(context, messageFromBack, AlertType.error);
        isLoad = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print(e);
      isLoad = false;
      _showAlert(
          context, "Произошла ошибка при оформлении заказа", AlertType.error);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> checkBalance(User user) async {
    try {
      final responce = await http.post(Uri.parse(urlOrderBalance),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode({"uuid_client": client['uuid_customer']}));
      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        balance = extractedData['balance'].toString();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkRate() async {
    try {
      final responce = await http.post(Uri.parse(urlRate),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode({"uuid_client": "0"}));
      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        course_rate = extractedData['rate'];
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkBalanceAndConfidence(
      BuildContext context, User user) async {
    // if (user.group_customers) {
    //   showAllClient(context);
    // } else {
    //   client = user.customers[0];
    // }

    try {
      String messageFromBack = '';

      final responce = await http.post(Uri.parse(urlOrderBalance),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode({"uuid_client": client['uuid_customer']}));
      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        print(extractedData);
        if (extractedData['limit_bool'] == true) {
          await checkBalance(user);

          _showCheckBalanceAndTrustPaymentDialog(
              context, user, extractedData['message_limit']);
        } else {
          _showCheckAnswerDialog(context, user);
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
    return false;
  }

  Future<String> getUnConfirmList(int uuid) async {
    try {
      final responce = await http.post(Uri.parse(urlOrderConfirm_list),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode({"uuid_mobile": uuid}));
      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        print(extractedData);
        return extractedData['results'];
      }
    } catch (e) {
      print(e);
      throw e;
    }
    return "";
  }

  Future<bool> sendConfirmation(
      BuildContext context, String uuid, Order order) async {
    try {
      print(basicAuth_sklad);
      final responce = await http.post(Uri.parse(urlOrderConfirm),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode({"uuid_sale": uuid}));
      print(responce);

      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        if (extractedData['status'] == true) {
          final finded_order = orders
              .firstWhere((element) => element.uuid_sale == order.uuid_sale);
          finded_order.status = StatusOrder.confirmed.name;
          await _db.changeOrderStatus(
              order.userId, order.status, order.uuid_sale);
          notifyListeners();
          return true;
        } else {
          _showAlert(context, "Произошла ошибка с подтверждением заказа",
              AlertType.error);
          return false;
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
    return false;
  }

  Future<bool> sendRejectOrder(int uuid, Order order) async {
    try {
      final responce = await http.post(Uri.parse(urlOrderReject),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode({"uuid_mobile": uuid}));
      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        print(extractedData['status']);
        if (extractedData['status'] == true) {
          final finded_order = orders
              .firstWhere((element) => element.uuid_sale == order.uuid_sale);
          finded_order.status = StatusOrder.refused.name;
          await _db.changeOrderStatus(
              order.userId, StatusOrder.newOrder.name, order.uuid_sale);
          notifyListeners();

          return true;
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
    return false;
  }

  Future<void> sendOrder(BuildContext context, User user) async {
    int uniq_id = UniqueKey().hashCode;
    Map<String, dynamic> args = {
      'client': client['uuid_customer'],
      'subdivision':
          context.read<AuthProvider>().subdivision['uuid_subdivision'],
      'uuid': uniq_id,
      'imei': user.messaging_token,
      'date': DateFormat("dd.MM.yyyy").format(DateTime.now()),
      'list_items': [],
      "additional_order": [],
      "bool_trust_payment": _isTrustPayment,
      "trust_payment_amount": _trustPaymentAmount,
      'term_trust_payment': _trustPaymentPeriod
    };

    for (Product element in cart) {
      final Map<String, dynamic> item = {
        'item': element.guid,
        'quantity': element.currentCount,
        'price': element.price,
        'priority': element.priority
      };
      args['list_items'].add(item);
    }

    for (Product element in additional_cart) {
      final Map<String, dynamic> item = {
        'item': element.guid,
        'quantity': element.currentCount,
        'price': element.price,
        'priority': element.priority
      };
      args['additional_order'].add(item);
    }
    print(args);
    try {
      final responce = await http.post(Uri.parse(urlOrder),
          headers: {"Authorization": basicAuth_sklad!}, body: jsonEncode(args));
      String uuid_sale = '';
      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        uuid_sale = extractedData['status']['uuid_sale'];

        _showAlert(context, "Заказ оформлен", AlertType.success);
        await checkBalance(user);
        print(extractedData);
      } else {}
      setOrderToDb(uniq_id, uuid_sale);
      clearAllCart();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> showAllClient(BuildContext contexts) async {
    late BuildContext dialogContext;
    await showDialog(
        barrierDismissible: false,
        context: contexts,
        builder: (BuildContext context) {
          dialogContext = context;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 30, bottom: 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      child: Text(
                    "Выберите контрагента:",
                    style: TextStyle(fontSize: 17),
                  )),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: context
                              .read<AuthProvider>()
                              .user
                              .customers
                              .length,
                          itemBuilder: (ctx, i) {
                            var client_f =
                                context.read<AuthProvider>().user.customers[i];
                            return InkWell(
                              onTap: () {
                                client = client_f;
                                notifyListeners();
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  client_f['customer_name'] ?? '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            );
                          })),
                ],
              ),
            ),
          );
        });
  }

  void _showCheckBalanceAndTrustPaymentDialog(
      contexts, User user, String messageFromBack) {
    late BuildContext dialogContext;
    showDialog(
        barrierDismissible: true,
        context: contexts,
        builder: (BuildContext context) {
          dialogContext = context;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 30, bottom: 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      child: Text(
                    messageFromBack,
                    style: TextStyle(fontSize: 15),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      user.trust_payment && double.parse(balance) > 0
                          ? ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => appColor),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10))),
                              onPressed: () async {
                                Navigator.pop(context);
                                _showTrustPaymentDialog(dialogContext, user);

                                notifyListeners();
                              },
                              child: Text(
                                "Доверительный платеж",
                                style: TextStyle(fontSize: 20),
                              ))
                          : SizedBox(),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.grey),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10))),
                          onPressed: () {
                            Navigator.pop(context);
                            isLoad = false;
                            notifyListeners();
                          },
                          child: Text(
                            "Отмена",
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
    ;
  }

  void _showTrustPaymentDialog(BuildContext contexts, User user) {
    late BuildContext dialogContext;
    showDialog(
        barrierDismissible: true,
        context: contexts,
        builder: (BuildContext context) {
          dialogContext = context;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      child: Text(
                    "Оформить доверительный платеж ?",
                    style: TextStyle(fontSize: 17),
                  )),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Срок(День): ',
                                style: TextStyle(fontSize: 17)),
                            SizedBox(
                              width: 10,
                            ),
                            Text(client['trust_payment_period'].toString(),
                                style: TextStyle(fontSize: 17)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('Сумма платежа: ',
                                style: TextStyle(fontSize: 17)),
                            Text(((total - double.parse(balance)).toString()),
                                style: TextStyle(fontSize: 17)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      user.trust_payment
                          ? ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => appColor),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10))),
                              onPressed: () async {
                                _isTrustPayment = true;
                                _trustPaymentAmount =
                                    total - double.parse(balance);
                                _trustPaymentPeriod =
                                    client['trust_payment_period'];
                                Navigator.pop(context);
                                _showCheckAnswerDialog(context, user);

                                notifyListeners();
                              },
                              child: Text(
                                "✅",
                                style: TextStyle(fontSize: 20),
                              ))
                          : SizedBox(),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.grey),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10))),
                          onPressed: () {
                            Navigator.pop(context);
                            isLoad = false;
                            notifyListeners();
                          },
                          child: Text(
                            "❌",
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showCheckAnswerDialog(contexts, User user) {
    late BuildContext dialogContext;
    showDialog(
        barrierDismissible: false,
        context: contexts,
        builder: (BuildContext context) {
          dialogContext = context;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 30, bottom: 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      child: Text(
                    "Вы уверены что хотите оформить заказ ?",
                    style: TextStyle(fontSize: 16),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => appColor),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10))),
                          onPressed: () async {
                            Navigator.pop(context);

                            await sendOrder(context, user);

                            isLoad = false;
                            notifyListeners();
                          },
                          child: Text(
                            "ДА",
                            style: TextStyle(fontSize: 20),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.grey),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10))),
                          onPressed: () {
                            Navigator.pop(context);
                            isLoad = false;
                            notifyListeners();
                          },
                          child: Text(
                            "Отмена",
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> setOrderToDb(int uniq_id, String uuid_sale) async {
    DatabaseHelper _db = DatabaseHelper();
    final List<Product> orderCart = [];
    final List<Product> orderAdditionsCart = [];
    List<Map<String, dynamic>> orderList = [];
    List<Map<String, dynamic>> orderAdditions = [];
    for (var element in cart) {
      Map<String, dynamic> item = {
        'uuid': element.guid,
        'quantity': element.currentCount
      };
      orderCart.add(element);
    }
    for (var element in additional_cart) {
      Map<String, dynamic> item = {
        'uuid': element.guid,
        'quantity': element.currentCount
      };
      orderAdditionsCart.add(element);
    }
    Order order = Order(
        uniq_id,
        orders.length + 1,
        orderCart,
        orderAdditionsCart,
        total,
        DateFormat("dd.MM.yy HH:mm").format(DateTime.now()),
        StatusOrder.newOrder.name,
        uuid_sale,
        false);

    orders.add(order);
    for (var item in order.products) {
      orderList.add(item.toMap());
    }

    for (var item in additional_cart) {
      orderAdditions.add(item.toMap());
    }

    Map<String, dynamic> orderToMap = {
      'userId': uniq_id,
      'number': order.number,
      'products': json.encode(orderList),
      'addition_order': json.encode(orderAdditions),
      'total': total,
      'date': order.date,
      'status': order.status,
      'uuid_sale': order.uuid_sale,
      'is_not_confirm': order.is_not_confirm
    };

    print(orderToMap);
    await _db.insertOrder(orderToMap);
    // final order_box = getOrdersFromDb().get('orders');

    // if (order_box != null) {
    //   order_box.orders.add(orderToMap);
    //   order_box.save();
    //   notifyListeners();
    // } else {
    //   getOrdersFromDb().put("orders", Orders([orderToMap]));
    // }
  }

  Map<String, dynamic> _createOrderForRequest(BuildContext context, User user) {
    imperfective_answer.clear();
    popular_answer.clear();
    remainders_answer.clear();
    haslimit = false;
    final Map<String, dynamic> order = {
      "client_uuid": client['uuid_customer'],
      "user": {"name": user.name, "id": user.id},
      "order_price": total,
      "no_check": false,
      'results': []
    };
    final List<Product> orderCart = [];
    final List<Product> orderAdditions = [];

    // АШ 205/60R16 WATERFALL ECO dynamic -> нагрузочный товар
    // d2844e9e-7b1f-11e2-a121-8495fb95ddc3 -> контрагент с долгом
    for (var element in cart) {
      Map<String, dynamic> item = {
        'uuid': element.guid,
        'quantity': element.currentCount
      };
      order['results'].add(item);
      orderCart.add(element);
    }

    for (var product in additional_cart) {
      orderAdditions.add(product);
    }

    return order;
  }

  void _checkItemsFromResponce(Map<String, dynamic> data, List<Product> items) {
    if (data['results'].length > 0 ||
        data['results_remainder'].length > 0 ||
        data['results_running'].length > 0) {
      // Check the remaining items
      for (var element in data['results_remainder']) {
        final item = items.firstWhere((e) => e.guid == element['uuid']);
        if (item != null) {
          Map<String, dynamic> object = {
            "product": item,
            "no_enough": element['no_enough']
          };
          remainders_answer.add(object);
        }
      }
      // Check the running items
      for (var element in data['results_running']) {
        final item = items.firstWhere((e) => e.guid == element['uuid']);
        if (item != null) {
          Map<String, dynamic> object = {
            "product": item,
            "count": element['quantity']
          };
          popular_answer.add(object);
        }
      }
      // Check the load items
      for (var element in data['results']) {
        final item = items.firstWhere((e) => e.guid == element['uuid']);
        if (item != null) {
          Map<String, dynamic> object = {
            "product": item,
            "count": element['quantity']
          };

          imperfective_answer.add(object);
        }
      }
      if (data['results'].length > 0) {
        imperfective_text = data['types_load'][0]['product_type'] +
            ": " +
            data['types_load'][0]['quantity'].toString();
      }
    }
  }

  void _showAlert(
      BuildContext context, String messageForAlert, AlertType type) {
    Alert(
      context: context,
      type: type,
      closeIcon: SizedBox(),
      buttons: [
        // DialogButton(
        //     child: const Text(
        //       "OK",
        //       style: TextStyle(fontSize: 18, color: Colors.white),
        //     ),
        //     onPressed: () {
        //       Navigator.of(context, rootNavigator: true).pop();
        //     })
      ],
      title: messageForAlert,
    ).show();
  }

  Future<void> deleteData() async {
    DatabaseHelper _db = DatabaseHelper();
    await _db.deleteOrders();
    orders.clear();
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    DatabaseHelper _db = DatabaseHelper();
    await _db.deleteOrders();
    orders.clear();
    notifyListeners();
  }

  void changeTotalPrice() {
    total = total_additional +
        cart.fold(
            0,
            (previousValue, element) =>
                previousValue + (element.currentCount * element.price));
    total_count = cart.fold(
        0, (previousValue, element) => previousValue + element.currentCount);
    notifyListeners();
  }

  Future<void> changeIsNotConfirmed(Order order, bool status) async {
    order.is_not_confirm = true;
    await _db.changeOrderIsNotConfirmed(order.userId, status);
    var result = await _db.selectOrder(order.userId);

    notifyListeners();
  }

  void changeTotalPriceAdditionalCart() {
    total_additional = additional_cart.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.currentCount * element.price));
    total_count_additional = additional_cart.fold(
        0, (previousValue, element) => previousValue + element.currentCount);
    notifyListeners();
  }

  void changeCurrentCountFromInput(int count, Product product) {
    if (count != 0) {
      product.currentCount = count;
    }
    notifyListeners();
  }

  void changeCurrentCount(String type, Product product) {
    if (type == "DEC") {
      if (product.currentCount >= 1) {
        product.currentCount = product.currentCount - 1;
        if (product.currentCount < 1) {
          deleteFromCart(product);
          deleteFromAdditionCart(product);
        }
        notifyListeners();
      } else if (product.currentCount < 1) {
        deleteFromCart(product);
        deleteFromAdditionCart(product);
      }
    } else {
      product.currentCount = product.currentCount + 1;
      notifyListeners();
    }
    changeTotalPrice();
  }

  void changePriorityProduct(double priority, Product product) {
    final _findedProduct =
        cart.firstWhere((element) => element.id == element.id);
    // if (priority > 4) {
    //   _findedProduct.priority = "Высокий";
    // } else if (priority > 3 && priority < 5) {
    //   _findedProduct.priority = "Средний";
    // } else {
    //   _findedProduct.priority = "Низкий";
    // }
    _findedProduct.priority = priority;
    notifyListeners();
  }

  void addProductToCart(int count, Product product) {
    product.currentCount = count;
    final findProduct = cart.firstWhere((element) => element.id == product.id,
        orElse: () => Product(0, "", "", "", "", "", "", "", 0, 0, 0, 0));
    if (findProduct.id == 0) {
      addToCart(product);
    }
    notifyListeners();
  }

  void addProductToAdditionalCart(int count, Product product) {
    product.currentCount = count;
    final findProduct = cart.firstWhere((element) => element.id == product.id,
        orElse: () => Product(0, "", "", "", "", "", "", "", 0, 0, 0, 0));
    if (findProduct.id == 0) {
      addToAdditionalCart(product);
    }
    notifyListeners();
  }

  void deleteFromCart(Product product) {
    cart.removeWhere((element) => element.id == product.id);
    product.currentCount = 0;
    changeTotalPrice();
    notifyListeners();
  }

  void deleteFromAdditionCart(Product product) {
    additional_cart.removeWhere((element) => element.id == product.id);
    product.currentCount = 0;
    changeTotalPrice();
    notifyListeners();
  }

  void deleteOrder(Order order) {
    orders.removeWhere((element) => element.number == order.number);

    notifyListeners();
  }

  void clearAllCart() {
    _isTrustPayment = false;
    _trustPaymentAmount = 0;
    _trustPaymentPeriod = 1;
    for (var element in cart) {
      element.currentCount = 0;
    }
    cart.clear();
    additional_cart.clear();
    popular_answer.clear();
    imperfective_answer.clear();
    remainders_answer.clear();
    total = 0;

    productProvider.clearAllCountItems();
    notifyListeners();
  }

  void clearAdditionCart() {
    additional_cart.clear();
    total_additional = 0;
    total_count_additional = 0;
    changeTotalPrice();
    notifyListeners();
  }
}
