import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:device_information/device_information.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/models/Message.dart' as MessageModel;
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/services/database_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher')));

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );

  //service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  notificationListener(flutterLocalNotificationsPlugin);
  // Timer.periodic(const Duration(seconds: 1), (timer) {
  //   chanel = connectWs();
  //   _connectionStatus = true;

  // );
}

WebSocketChannel connectWs() {
  try {
    return WebSocketChannel.connect(Uri.parse("ws://188.225.76.52:8999"));
  } catch (e) {
    print("Error, can not connect WS " + e.toString());
    Future.delayed(const Duration(seconds: 1));
    return connectWs();
  }
}

void notificationListener(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  var lis_future = await _databaseHelper.getImei();
  String imei = lis_future[0];
  WebSocketChannel chanel =
      WebSocketChannel.connect(Uri.parse("ws://188.225.76.52:8111"));
  // chanel.sink.add(
  //     json.encode({"meta": "join", "message": "hi!! Im Mobile", "room": imei}));
  bool _connectionStatus = false;

  Future<void> checkConnection() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      try {
        chanel = WebSocketChannel.connect(Uri.parse("ws://188.225.76.52:8111"));

        _connectionStatus = true;
        return;
      } catch (e) {
        print("Error, can not connect WS " + e.toString());
        _connectionStatus = false;
      }
    });
  }

  Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_connectionStatus == false) {
      checkConnection();
    } else {
      chanel.sink.add(json
          .encode({"meta": "join", "message": "hi!! Im Mobile", "room": imei}));
      chanel.stream.listen((event) async {
        DatabaseHelper _db = DatabaseHelper();

        var responce = json.decode(event) as Map<String, dynamic>;

        await _db.insertMessage({"id": Random().nextInt(1000), "text": event});

        if (responce['status'] == 'New') {
          flutterLocalNotificationsPlugin.show(
            888,
            responce['message'],
            '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'my_foreground', 'MY FOREGROUND SERVICE',
                  icon: 'ic_bg_service_small',
                  ongoing: true,
                  channelShowBadge: true,
                  indeterminate: true,
                  priority: Priority.min,
                  importance: Importance.max),
            ),
          );
        } else if (responce['status'] == 'New_Division') {
          flutterLocalNotificationsPlugin.show(
            888,
            responce['message'],
            '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'my_foreground', 'MY FOREGROUND SERVICE',
                  icon: 'ic_bg_service_small',
                  ongoing: true,
                  importance: Importance.max),
            ),
          );
        } else if (responce['status'] == 'price_list') {
          flutterLocalNotificationsPlugin.show(
            888,
            responce['message'],
            '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'my_foreground', 'MY FOREGROUND SERVICE',
                  icon: 'ic_bg_service_small',
                  ongoing: true,
                  importance: Importance.max),
            ),
          );
        } else if (responce['status'] == 'money') {
          flutterLocalNotificationsPlugin.show(
            888,
            responce['message'],
            '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'my_foreground', 'MY FOREGROUND SERVICE',
                  icon: 'ic_bg_service_small',
                  ongoing: true,
                  importance: Importance.max),
            ),
          );
        } else {
          await _db.changeOrderStatus(
              responce['uuid'], responce['status'], responce['uuid_sale']);

          flutterLocalNotificationsPlugin.show(
            888,
            responce['message'],
            '${DateFormat("dd-MM-yyyy - kk:mm").format(DateTime.now())}',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'my_foreground', 'MY FOREGROUND SERVICE',
                  icon: 'ic_bg_service_small',
                  ongoing: true,
                  importance: Importance.max),
            ),
          );
        }
        _connectionStatus = true;
      }, onDone: () async {
        // chanel.sink.add(json.encode(
        //     {"meta": "leave", "message": "hi!! Im Deleted", "room": imei}));
        print("Socket closed");
        _connectionStatus = false;

        //service.stopSelf();
      }, onError: (e) {
        _connectionStatus = false;
        print("Socket error");
        print(e);
      });
    }
  });
}

Future<String> getDeviceSerialNumber(name) async {
  // Map idMap = await AndroidMultipleIdentifier.idMap;

  // String imei = idMap["imei"];
  try {
    var platformVersion = await DeviceInformation.platformVersion;
    var imeiNo = await DeviceInformation.deviceIMEINumber;
    var modelName = await DeviceInformation.deviceModel;
    var manufacturer = await DeviceInformation.deviceManufacturer;
    var apiLevel = await DeviceInformation.apiLevel;
    var deviceName = await DeviceInformation.deviceName;
    var productName = await DeviceInformation.productName;
    var cpuType = await DeviceInformation.cpuName;
    var hardware = await DeviceInformation.hardware;
    return imeiNo.toString();
  } catch (e) {
    print(e);
  }

  return name;
}
