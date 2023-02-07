import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tires_app/providers/auth_provider.dart';

void showToastConnection(fToast) {
  String message = "Отсутствует интернет соединение";
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.redAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          child: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    // gravity: ToastGravity.TOP,
    toastDuration: Duration(seconds: 2),
  );
}

void showAlert(BuildContext context, String messageForAlert, AlertType type) {
  Alert(
    context: context,
    type: type,
    buttons: [
      DialogButton(
          child: const Text(
            "OK",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          })
    ],
    title: messageForAlert,
  ).show();
}

void showToastMessage(fToast, BuildContext context) {
  String message = context.read<AuthProvider>().message;
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: context.read<AuthProvider>().isAuth
          ? Colors.greenAccent
          : Colors.redAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 2),
  );
}
