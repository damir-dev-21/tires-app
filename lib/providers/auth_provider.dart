// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tires_app/constants/config.dart';
import 'package:tires_app/models/User/User.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/services/database_helper.dart';
import 'package:tires_app/services/notification_service.dart';
import 'package:tires_app/widgets/notifications.dart';

class AuthProvider extends ChangeNotifier {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  Box<User> getLangs() => Hive.box<User>('users');
  User user = User().defaultUser();
  bool isAddition = true;

  bool isAuth = false;
  bool isLoad = false;
  String message = '';
  bool hasConnect = true;
  int langIndex = 0;
  var subdivision = {};

  Future<void> changeLang(int idx) async {
    langIndex = idx;
    notifyListeners();
  }

  void changeConnect(String status) {
    if (status == 'none') {
      hasConnect = false;
      notifyListeners();
    } else {
      hasConnect = true;
      notifyListeners();
    }
  }

  Future<void> checkConnection() async {
    var connect = await (Connectivity().checkConnectivity());
    if (connect == ConnectivityResult.none) {
      changeConnect('none');
      notifyListeners();
    } else if (connect == ConnectivityResult.mobile) {
      changeConnect('mobile');
    } else if (connect == ConnectivityResult.wifi) {
      changeConnect('wifi');
    }
    notifyListeners();
  }

  Future<void> getStatus() async {
    await checkConnection();
    final userDb = getLangs().get('1')!;
    final myLang = userDb.language;

    if (userDb != null) {
      user = User()
        ..id = userDb.id
        ..language = userDb.language
        ..name = userDb.name
        ..password = userDb.password
        ..token = userDb.token
        ..customers = userDb.customers
        ..imei = userDb.imei
        ..messaging_token = userDb.messaging_token
        ..act_sverki = userDb.act_sverki
        ..act_sverki_detail = userDb.act_sverki_detail
        ..addition = userDb.addition
        ..balance = userDb.balance
        ..deficit = userDb.deficit
        ..load = userDb.load
        ..group_customers = userDb.group_customers
        ..bonus = userDb.bonus
        ..subdivision_access = userDb.subdivision_access
        ..subdivisions = userDb.subdivisions
        ..trust_payment = userDb.trust_payment;
      isAuth = true;
      isAddition = user.addition;

      if (user.subdivisions.length == 1) {
        subdivision = user.subdivisions[0];
      }

      if (myLang != null) {
        langIndex = myLang;
      } else {
        langIndex = 0;
      }
      notifyListeners();
    }
  }

  Future<void> login(name, passwordUser, BuildContext context) async {
    try {
      var imei = await getDeviceSerialNumber(name);
      FirebaseMessaging _messaging = FirebaseMessaging.instance;
      var token;
      //dy6ihDhIQR-nj6hLOI8ZUY:APA91bEgRdIQ3J6nZcfGs2Vl1YT0p7gH-r2oUhccLktXbmMXa36ImmrUncMg1FUIUR8ue6mYQhaZpCRli9yoFm8Jen9Fc1xljl22XYfEwk5me-2L60IgTQ1hDv4nWtrQdZR4MSMt5b0g
      await _messaging.getToken().then((value) {
        print(value);
        token = value!;
      });
      print("my token " + token);
      print(imei);
      Map<String, dynamic> object = {
        "name": name,
        "password": passwordUser,
        "imei": imei,
        'token': token
      };

      isLoad = true;
      notifyListeners();
      final responce = await http.post(Uri.parse(urlLogin),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode(object));
      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        message = extractedData['message'];
        notifyListeners();
        if (extractedData['token'] != null) {
          extractedData['customers'].forEach((e) => {});
          List list_of_customers = [];
          extractedData['customers'].forEach((e) => list_of_customers.add(e));
          List list_of_subdivisions = [];
          extractedData['subdivision']
              .forEach((e) => list_of_subdivisions.add(e));

          print(extractedData['uuid_customer']);
          user = User()
            ..id = 1
            ..name = name
            ..password = passwordUser
            ..token = extractedData['token']
            ..language = 0
            ..customers = list_of_customers
            ..imei = imei
            ..messaging_token = token
            ..act_sverki = extractedData['act_sverki']
            ..act_sverki_detail = extractedData['act_sverki_detail']
            ..addition = extractedData['addition']
            ..balance = extractedData['balance']
            ..deficit = extractedData['deficit']
            ..load = extractedData['load']
            ..group_customers = extractedData['group_customers']
            ..bonus = extractedData['bonus']
            ..subdivision_access = extractedData['subdivision_access']
            ..subdivisions = list_of_subdivisions
            ..trust_payment = extractedData['trust_payment'];

          isAddition = user.addition;

          subdivision = user.subdivisions[0];
          context.read<CartProvider>().client = user.customers[0];
          getLangs().put('1', user);
          _databaseHelper.insertImei({"imei": imei});
          checkConnection();
          message = extractedData['message'];
          isAuth = true;
          isLoad = false;
          context.router.push(const MainRoute());
        } else {
          isLoad = false;
          message = extractedData['message'];
          notifyListeners();
        }
        notifyListeners();
      } else {
        isLoad = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      isAuth = false;
      isLoad = false;
      message = 'Error';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> reg(name, passwordUser, BuildContext context) async {
    try {
      Map<String, dynamic> object = {
        "name": name,
        "password": passwordUser,
      };
      String username = 'Программист';
      String password = '1598753';
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$username:$password'));
      isLoad = true;
      notifyListeners();
      final responce = await http.post(Uri.parse(urlReg),
          headers: {'Authorization': basicAuth}, body: jsonEncode(object));

      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        message = extractedData['message'];

        if (extractedData['message'] !=
            'Пользователь с таким именем уже есть') {
          context.router.push(const LoginRoute());
        }
        isLoad = false;
        notifyListeners();
      }
    } catch (e) {
      isLoad = false;
      message = 'Error';

      print(e);
      rethrow;
    }
  }

  Future<bool> sendOpinion(String theme, String content) async {
    try {
      isLoad = true;
      notifyListeners();
      var text_header =
          "Пользователь: " + user.name + " ->" + "Мобильное приложение" + '\n';
      var text_content_theme = "Тема: " + theme + '\n';
      var text_content_content = "Содержание: " + content + '\n';

      final responce = await http.post(Uri.parse(urlSendOpinion),
          headers: {"content-type": "application/json; charset=utf-8"},
          body: jsonEncode({
            "text": text_header + text_content_theme + text_content_content
          }));
      print(responce.statusCode);
      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        if (body == '"Done"') {
          message = "Сообщение отправлено";
          return true;
        }
        message = "Произошла ошибка при отправке";
        return false;
      } else {
        isLoad = false;
        message = "Произошла ошибка при отправке";

        notifyListeners();
        return false;
      }
    } catch (e) {
      print(e);
      message = "Произошла ошибка при отправке";

      isLoad = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> showAllSubdivision(BuildContext contexts) async {
    late BuildContext dialogContext;
    await showDialog(
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
              height: MediaQuery.of(context).size.height / 3.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      child: Text(
                    "Доступные подразделения:",
                    style: TextStyle(fontSize: 17),
                  )),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: user.subdivisions.length,
                          itemBuilder: (ctx, i) {
                            var subdivision_f = user.subdivisions[i];
                            return InkWell(
                              onTap: () {
                                subdivision = subdivision_f;
                                notifyListeners();
                                Navigator.pop(context);
                                final fToast = FToast();
                                fToast.init(context);
                                showToastMessage_subdivision(fToast, context,
                                    'Установлено подразделение ${subdivision_f['subdivision_name']}');
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                color: Color.fromARGB(255, 238, 238, 238),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  subdivision_f['subdivision_name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            );
                          })),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 1.4,
                  //   child: ElevatedButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //       child: Text("Отмена")),
                  // )
                ],
              ),
            ),
          );
        });
  }

  void showAlert(BuildContext context, String messageForAlert, AlertType type) {
    Alert(
      context: context,
      type: type,
      closeIcon: SizedBox(),
      closeFunction: () {
        Navigator.of(context).pop();
      },
      buttons: [
        // DialogButton(
        //     child: const Text(
        //       "OK",
        //       style: TextStyle(fontSize: 18, color: Colors.white),
        //     ),
        //     onPressed: () {
        //       print(context);
        //       notifyListeners();
        //     })
      ],
      title: messageForAlert,
    ).show();
  }

  Future<void> logout(BuildContext context) async {
    try {
      var imei = await getDeviceSerialNumber(user.name);
      Map<String, dynamic> object = {"name": user.name, "imei": imei};
      print(object);
      final responce = await http.post(
          Uri.parse('http://web.corp.siyob.uz:9696/sklad/hs/mobile/logout/'),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode(object));
      print(responce.statusCode);
      isAuth = false;
      isLoad = false;
      message = '';
      DatabaseHelper _db = DatabaseHelper();

      getLangs().delete("1");
      _db.deleteImei();
      context.router.push(const LoginRoute());
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      var imei = await getDeviceSerialNumber(user.name);
      Map<String, dynamic> object = {"name": user.name, "imei": imei};
      print(object);
      final responce = await http.post(
          Uri.parse('http://web.corp.siyob.uz:9696/sklad/hs/mobile/logout/'),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode(object));
      print(responce.statusCode);
      isAuth = false;
      isLoad = false;
      message = '';
      DatabaseHelper _db = DatabaseHelper();

      getLangs().delete("1");
      _db.deleteImei();
      context.router.push(const LoginRoute());
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
