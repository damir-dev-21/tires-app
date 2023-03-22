import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/services/languages.dart';
import 'package:tires_app/widgets/notifications.dart';

import '../../providers/auth_provider.dart';
import '../../routes/router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObsured = true;
  late FToast fToast;

  String name = '';
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Stack(children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(langs[authProvider.langIndex]['enter'],
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  key: const ValueKey('email'),
                  onChanged: (e) {
                    setState(() {
                      name = e;
                    });
                  },
                  cursorColor: textColorDark,
                  decoration: InputDecoration(
                      labelText: langs[authProvider.langIndex]['login'],
                      focusColor: appColor,
                      labelStyle: const TextStyle(color: textColorDark),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: textColorDark),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                child: TextField(
                  keyboardType: TextInputType.text,
                  key: const ValueKey('password'),
                  onChanged: (text) => {
                    setState(() {
                      password = text;
                    })
                  },
                  cursorColor: textColorDark,
                  obscureText: isObsured,
                  decoration: InputDecoration(
                      focusColor: appColor,
                      labelStyle: const TextStyle(color: textColorDark),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: textColorDark),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      suffixIconColor: appColor,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObsured ? Icons.visibility : Icons.visibility_off,
                          color: textColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            isObsured = !isObsured;
                          });
                        },
                      ),
                      labelText: langs[authProvider.langIndex]['password'],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 17,
              ),
              GestureDetector(
                onTap: () async {
                  await authProvider.login(name, password, context);

                  showToastMessage(fToast, context);
                },
                child: context.read<AuthProvider>().isLoad
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        key: const ValueKey('signIn'),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: appColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: Text(
                            langs[authProvider.langIndex]['enter'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      langs[authProvider.langIndex]['check_user'],
                      style: const TextStyle(color: textColorDark),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.router.push(const RegRoute());
                      },
                      child: Text(
                        langs[authProvider.langIndex]['reg'],
                        style: const TextStyle(color: appColor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
            bottom: 30,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Text("Powered by Venons"),
                        Image.asset("assets/primary_logo.png", width: 70),
                      ],
                    )))),
        Positioned(
            top: 0,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/SiyobAgromash.png",
                          width: 200,
                          height: 200,
                        ),
                      ],
                    )))),
      ])),
    );
  }
}
