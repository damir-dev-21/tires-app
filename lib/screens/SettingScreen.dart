import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/services/languages.dart';

import '../constants/colors.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(langs[authProvider.langIndex]['settings']),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                cartProvider.deleteData();
              },
              child: Text(
                langs[authProvider.langIndex]['delete_all'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                var dialogContext = context;
                showDialog(
                    builder: (dialogContext) {
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
                                "Вы уверены что хотите удалить ваш аккаунт?",
                                style: TextStyle(fontSize: 16),
                              )),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => appColor),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: 30,
                                                  vertical: 10))),
                                      onPressed: () async {
                                        cartProvider.deleteAccount();
                                        authProvider.deleteAccount(context);
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
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
                                                  horizontal: 30,
                                                  vertical: 10))),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
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
                    },
                    context: dialogContext);
              },
              child: Text(
                langs[authProvider.langIndex]['delete_account'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
