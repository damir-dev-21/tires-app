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

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
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
            (NotificationResponse notificationResponse) async {});
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
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}
