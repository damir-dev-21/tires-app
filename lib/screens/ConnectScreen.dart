import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    // Workmanager().initialize(
    //   callbackDispatcher,
    //   isInDebugMode: false,
    // );

    // Workmanager().registerPeriodicTask("1", getProducts,
    //     frequency: const Duration(minutes: 30));

    // Workmanager().registerPeriodicTask(
    //   "2",
    //   dropUser,
    //   frequency: const Duration(minutes: 30),
    // );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseNotifications.setupFirebase(context);
    });
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
        body: authProvider.isAuth ? MainScreen() : LoginScreen());
  }
}
