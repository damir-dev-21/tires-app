// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationHandler {
//   static final flutterLocalNotificationPlugin =
//       FlutterLocalNotificationsPlugin();
//   static late BuildContext myContext;

//   static void initNotification(BuildContext context) {
//     myContext = context;
//     var initAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
//     var initIOS = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//     var initSetting =
//         InitializationSettings(android: initAndroid, iOS: initIOS);

//     flutterLocalNotificationPlugin.initialize(initSetting);
//   }

//   static void onSelectNotification(String? payload) {
//     if (payload != null) {
//       print("Get payload : $payload");
//     }
//   }

//   static Future onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     showDialog(
//         context: myContext,
//         builder: (context) => CupertinoAlertDialog(
//               title: Text(title!),
//               content: Text(body!),
//               actions: [
//                 CupertinoDialogAction(
//                   isDefaultAction: true,
//                   child: Text("OK"),
//                   onPressed: () =>
//                       Navigator.of(context, rootNavigator: true).pop(),
//                 )
//               ],
//             ));
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/models/Message.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tires_app/screens/NotificationScreen.dart';

import '../main.dart';
import '../models/Product/Product.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification(BuildContext context) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      handleMessage(context, notificationResponse.payload);
    });
  }

  void handleMessage(BuildContext context, payload) async {
    await context.read<ProductProvider>().getSynchronization(null);

    context.read<CartProvider>().checkOrders();
    var responce = json.decode(payload);
    openNotification(responce, context);
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin
        .show(id, title, body, await notificationDetails(), payload: payLoad);
  }

  void openNotification(Map<String, dynamic> responce, BuildContext context) {
    if (responce['status'] == 'New') {
      List<Product> allProducts = context.read<ProductProvider>().products;
      List<Map<String, dynamic>> notificationProducts = [];
      responce['goods'].forEach((e) {
        Product product = allProducts.firstWhere(
            (element) => element.guid == e['guid'],
            orElse: () => Product(0, '', '', '', '', '', '', '', 0, 0, 0, 0));
        if (product.id != 0) {
          notificationProducts.add(product.toMap());
        }
      });
      context.router
          .push(NotificationDetailRoute(products: notificationProducts));
    } else if (responce['status'] == 'New_Division') {
      List<Product> allProducts = context.read<ProductProvider>().products;
      List<Map<String, dynamic>> notificationProducts = [];
      responce['goods'].forEach((e) {
        Product product = allProducts.firstWhere(
            (element) => element.guid == e['guid'],
            orElse: () => Product(0, '', '', '', '', '', '', '', 0, 0, 0, 0));
        if (product.id != 0) {
          notificationProducts.add(product.toMap());
        }
      });
      context.router
          .push(NotificationDetailRoute(products: notificationProducts));
    } else if (responce['status'] == 'price_list') {
      List<dynamic> allNotifications =
          context.read<ProductProvider>().list_of_messages;

      List<dynamic> price_notifications = [];
      allNotifications.forEach((e) {
        if (e.status == 'Прайс лист') {
          price_notifications.add(e);
        }
      });

      context.router.push(
          NotificationCategoryDetailRoute(notifications: price_notifications));
    } else if (responce['status'] == 'money') {
      List<dynamic> allNotifications =
          context.read<ProductProvider>().list_of_messages;
      List<dynamic> money_notifications = [];
      allNotifications.forEach((e) {
        if (e.status == 'Поступление_Касса') {
          money_notifications.add(e);
        }
      });

      context.router.push(
          NotificationCategoryDetailRoute(notifications: money_notifications));
    } else if (responce['status'] == 'balance') {
      List<dynamic> allNotifications =
          context.read<ProductProvider>().list_of_messages;
      List<dynamic> money_notifications = [];
      allNotifications.forEach((e) {
        if (e.status == 'Акт сверки') {
          money_notifications.add(e);
        }
      });

      context.router.push(
          NotificationCategoryDetailRoute(notifications: money_notifications));
    } else {
      List<dynamic> allNotifications =
          context.read<ProductProvider>().list_of_messages;
      List<dynamic> order_notifications = [];
      allNotifications.forEach((e) {
        if (e.status == 'Заказ') {
          order_notifications.add(e);
        }
      });

      context.router.push(
          NotificationCategoryDetailRoute(notifications: order_notifications));
    }
  }
}
