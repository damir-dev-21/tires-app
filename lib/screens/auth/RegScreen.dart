import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/widgets/notifications.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  bool isObsured = true;
  late FToast fToast;

  String name = '';
  String phoneNumber = '';
  String password = '';
  String repeatPassword = '';

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Регистрация',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    onChanged: (e) {
                      setState(() {
                        name = e;
                      });
                    },
                    cursorColor: textColorDark,
                    decoration: InputDecoration(
                        focusColor: appColor,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: textColorDark),
                        ),
                        labelText: 'Имя пользователя',
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
                    onChanged: (text) => {
                      setState(() {
                        password = text;
                      })
                    },
                    cursorColor: textColorDark,
                    obscureText: isObsured,
                    decoration: InputDecoration(
                        focusColor: appColor,
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: textColorDark),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
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
                        labelText: 'Пароль ',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    await context
                        .read<AuthProvider>()
                        .reg(name, password, context);
                    showToastMessage(fToast, context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: appColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: context.read<AuthProvider>().isLoad
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Зарегистрироваться',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      )),
                ),
                const SizedBox(
                  height: 17,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Уже есть аккаунт? ',
                        style: TextStyle(color: textColorDark),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.router.push(LoginRoute());
                        },
                        child: const Text(
                          'Войти',
                          style: TextStyle(color: appColor),
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
        ],
      )),
    );
  }
}
