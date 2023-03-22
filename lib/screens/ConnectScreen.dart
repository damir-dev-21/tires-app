// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/screens/MainScreen.dart';
import 'package:tires_app/screens/auth/LoginScreen.dart';
import 'package:tires_app/services/background_fetch.dart';
import 'package:tires_app/services/firebase_notification_handler.dart';
import 'package:tires_app/widgets/notifications.dart';
// import 'package:workmanager/workmanager.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({Key? key}) : super(key: key);

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  late FToast fToast;
  FirebaseNotifications firebaseNotifications = FirebaseNotifications();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseNotifications.setupFirebase(context);
    });
    _checkVersion();
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
        androidId: 'com.devdamir.tires', iOSId: 'com.devdamir.tires');
    final status = await newVersion.getVersionStatus();
    if (status!.canUpdate) {
      newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: 'Обновить приложение',
          dismissButtonText: 'Позже',
          dialogText:
              "Доступно новая версия приложения, пожалуйста обновите приложение",
          dismissAction: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          updateButtonText: "Обновить");
    }
    print("Device version: " + status.localVersion);
    print("Store version: " + status.storeVersion);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    Future.delayed(Duration.zero, () {
      if (authProvider.hasConnect == false) {
        showToastConnection(fToast);
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // body: authProvider.isAuth ? MainScreen() : LoginScreen()
      body: MainScreen(),
    );
  }
}
