import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:tires_app/services/database_helper.dart';
import 'package:tires_app/services/notification_handler.dart';

class FirebaseNotifications {
  late FirebaseMessaging _messaging;
  late BuildContext myContext;

  void setupFirebase(BuildContext context) {
    _messaging = FirebaseMessaging.instance;
    // NotificationHandler.initNotification(context);
    NotificationService().initNotification();
    firebaseCloudMessageListener(context);
    myContext = context;
  }

  void firebaseCloudMessageListener(BuildContext context) async {
    NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    print('Settings ${settings.authorizationStatus}');

    _messaging.getToken().then((value) => print('MyToken: ${value}'));

    _messaging
        .subscribeToTopic("edmtdev_demo")
        .whenComplete(() => print("Subscribe OK"));

    FirebaseMessaging.onMessage.handleError((onError) {
      print(onError);
    }).listen((remoteMessage) {
      print("Receive ${remoteMessage}");

      if (Platform.isAndroid) {
        showNotification(remoteMessage.data, remoteMessage.data['message']);
      }

      if (Platform.isIOS) {
        print("iosss");
        showNotification(remoteMessage.data, remoteMessage.data['message']);

        // showDialog(
        //     context: myContext,
        //     builder: (context) => CupertinoAlertDialog(
        //           title: Text(remoteMessage.notification!.title!),
        //           content: Text(remoteMessage.notification!.body!),
        //           actions: [
        //             CupertinoDialogAction(
        //               isDefaultAction: true,
        //               child: Text("OK"),
        //               onPressed: () =>
        //                   Navigator.of(context, rootNavigator: true).pop(),
        //             )
        //           ],
        //         ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print('Receive open app: ${remoteMessage}');
    });
  }

  static void showNotification(title, body) async {
    var androidChannel = const AndroidNotificationDetails(
        "edmt.dev.flutter_firebase_messaging_test", 'My Channel ',
        channelDescription: 'Description',
        autoCancel: false,
        ongoing: true,
        importance: Importance.max,
        priority: Priority.high);
    var ios = DarwinNotificationDetails();

    // await NotificationHandler.flutterLocalNotificationPlugin.show(
    //     Random().nextInt(1000), title, body, platform,
    //     payload: 'My Paylload');

    var platform = NotificationDetails(android: androidChannel, iOS: ios);

    // await NotificationHandler.flutterLocalNotificationPlugin.show(
    //   888,
    //   'New message',
    //   '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
    //   const NotificationDetails(
    //       android: AndroidNotificationDetails(
    //           'my_foreground', 'MY FOREGROUND SERVICE',
    //           icon: 'ic_bg_service_small',
    //           ongoing: true,
    //           channelShowBadge: true,
    //           indeterminate: true,
    //           priority: Priority.min,
    //           importance: Importance.max),
    //       iOS: DarwinNotificationDetails()),
    // );

    DatabaseHelper _db = DatabaseHelper();
    print(title);
    print(body);
    var responce = json.decode(body) as Map<String, dynamic>;

    await _db.insertMessage({"id": Random().nextInt(1000), "text": body});

    if (responce['status'] == 'New') {
      NotificationService().showNotification(
        id: Random().nextInt(1000),
        title: responce['message'],
        body: '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
      );
      // await NotificationHandler.flutterLocalNotificationPlugin.show(
      //   888,
      //   responce['message'],
      //   '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
      //   const NotificationDetails(
      //       android: AndroidNotificationDetails(
      //           'my_foreground', 'MY FOREGROUND SERVICE',
      //           icon: 'ic_bg_service_small',
      //           ongoing: true,
      //           channelShowBadge: true,
      //           indeterminate: true,
      //           priority: Priority.min,
      //           importance: Importance.max),
      //       iOS: DarwinNotificationDetails()),
      // );
    } else if (responce['status'] == 'New_Division') {
      NotificationService().showNotification(
        id: Random().nextInt(1000),
        title: responce['message'],
        body: '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
      );
      // await NotificationHandler.flutterLocalNotificationPlugin.show(
      //   888,
      //   responce['message'],
      //   '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
      //   const NotificationDetails(
      //     android: AndroidNotificationDetails(
      //         'my_foreground', 'MY FOREGROUND SERVICE',
      //         icon: 'ic_bg_service_small',
      //         ongoing: true,
      //         importance: Importance.max),
      //   ),
      // );
    } else if (responce['status'] == 'price_list') {
      NotificationService().showNotification(
        id: Random().nextInt(1000),
        title: responce['message'],
        body: '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
      );
      // await NotificationHandler.flutterLocalNotificationPlugin.show(
      //   888,
      //   responce['message'],
      //   '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
      //   const NotificationDetails(
      //     android: AndroidNotificationDetails(
      //         'my_foreground', 'MY FOREGROUND SERVICE',
      //         icon: 'ic_bg_service_small',
      //         ongoing: true,
      //         importance: Importance.max),
      //   ),
      // );
    } else if (responce['status'] == 'money') {
      NotificationService().showNotification(
        id: Random().nextInt(1000),
        title: responce['message'],
        body: '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
      );
      // await NotificationHandler.flutterLocalNotificationPlugin.show(
      //   888,
      //   responce['message'],
      //   '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
      //   const NotificationDetails(
      //     android: AndroidNotificationDetails(
      //         'my_foreground', 'MY FOREGROUND SERVICE',
      //         icon: 'ic_bg_service_small',
      //         ongoing: true,
      //         importance: Importance.max),
      //   ),
      // );
    } else {
      NotificationService().showNotification(
        id: Random().nextInt(1000),
        title: responce['message'],
        body: '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
      );
      await _db.changeOrderStatus(
          responce['uuid'], responce['status'], responce['uuid_sale']);

      // await NotificationHandler.flutterLocalNotificationPlugin.show(
      //   888,
      //   responce['message'],
      //   '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
      //   const NotificationDetails(
      //     android: AndroidNotificationDetails(
      //         'my_foreground', 'MY FOREGROUND SERVICE',
      //         icon: 'ic_bg_service_small',
      //         ongoing: true,
      //         importance: Importance.max),
      //   ),
      // );
    }
  }
}
