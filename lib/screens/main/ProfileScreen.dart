// ignore_for_file: file_names, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/services/languages.dart';
import 'package:tires_app/widgets/ProfileListItem.dart';
import 'package:tires_app/widgets/notifications.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isObsured = true;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  bool isLoad_balance = false;
  bool isLoad_exchange = false;
  bool isAuth = true;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    if (authProvider.isAuth) {
      _controller.text = authProvider.user.password;
      _controller2.text = authProvider.user.name;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          title: Image.asset(
            "assets/whiteLogo.png",
            height: 40,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                authProvider.isAuth
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: Text(
                              authProvider.user.name[0],
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: TextField(
                                  readOnly: true,
                                  controller: _controller2,
                                  onChanged: (e) {},
                                  cursorColor: textColorDark,
                                  decoration: InputDecoration(
                                      focusColor: appColor,
                                      labelStyle:
                                          const TextStyle(color: textColorDark),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: textColorDark),
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                      label: Text(langs[authProvider.langIndex]
                                          ['login'])),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: TextField(
                                  controller: _controller,
                                  onChanged: (e) {},
                                  readOnly: true,
                                  cursorColor: textColorDark,
                                  obscureText: isObsured,
                                  decoration: InputDecoration(
                                    focusColor: appColor,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isObsured
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: textColorDark,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isObsured = !isObsured;
                                        });
                                      },
                                    ),
                                    labelStyle:
                                        const TextStyle(color: textColorDark),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: textColorDark),
                                        borderRadius: BorderRadius.circular(2)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    label: Text(langs[authProvider.langIndex]
                                        ['password']),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : SizedBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.router.push(const OrdersRoute());
                      },
                      child: Text(
                        langs[authProvider.langIndex]['myOrders'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    authProvider.isAuth
                        ? ProfileListItem(
                            authProvider.isAuth,
                            const CollationActRoute(),
                            langs[authProvider.langIndex]['akt_sverki'],
                            authProvider.user,
                          )
                        : SizedBox(),
                    authProvider.isAuth
                        ? ProfileListItem(
                            authProvider.isAuth,
                            const CollationActDetailRoute(),
                            langs[authProvider.langIndex]['akt_sverki_detail'],
                            authProvider.user,
                          )
                        : SizedBox(),
                    authProvider.isAuth
                        ? ProfileListItem(
                            authProvider.isAuth,
                            const AccountBonusRoute(),
                            langs[authProvider.langIndex]['account_bonus'],
                            authProvider.user,
                          )
                        : SizedBox(),
                    authProvider.isAuth
                        ? ProfileListItem(
                            authProvider.isAuth,
                            const DeficitRoute(),
                            langs[authProvider.langIndex]['deficit_list'],
                            authProvider.user,
                          )
                        : SizedBox(),
                    authProvider.isAuth
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                GestureDetector(
                                  onTap: () {
                                    if (!authProvider.isAuth) {
                                      showToastMessage_auth(fToast, context,
                                          'Необходимо войти в приложение');
                                      return;
                                    }
                                    authProvider.user.subdivision_access
                                        ? authProvider
                                            .showAllSubdivision(context)
                                        : authProvider.showAlert(context,
                                            "Доступ запрещен", AlertType.error);
                                  },
                                  child: Text(
                                    langs[authProvider.langIndex]
                                        ['subdivision'],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 20,
                                )
                              ])
                        : SizedBox(),
                    authProvider.isAuth
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (!authProvider.isAuth) {
                                      showToastMessage_auth(fToast, context,
                                          'Необходимо войти в приложение');
                                      return;
                                    }
                                    try {
                                      setState(() {
                                        isLoad_exchange = true;
                                      });
                                      await cartProvider.checkRate();
                                      authProvider.showAlert(
                                          context,
                                          "Курс валюты: " +
                                              cartProvider.course_rate
                                                  .toString(),
                                          AlertType.success);
                                    } catch (e) {
                                      print(e);
                                      throw e;
                                    } finally {
                                      setState(() {
                                        isLoad_exchange = false;
                                      });
                                    }
                                  },
                                  child: isLoad_exchange
                                      ? CircularProgressIndicator()
                                      : Text(
                                          langs[authProvider.langIndex]
                                              ['exchange'],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 20,
                                )
                              ])
                        : SizedBox(),
                    ProfileListItem(
                        isAuth,
                        OpinionRoute(),
                        langs[authProvider.langIndex]['review'],
                        authProvider.user),
                    authProvider.isAuth
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (!authProvider.isAuth) {
                                      showToastMessage_auth(fToast, context,
                                          'Необходимо войти в приложение');
                                      return;
                                    }
                                    try {
                                      setState(() {
                                        isLoad_balance = true;
                                      });
                                      await cartProvider
                                          .checkBalance(authProvider.user);
                                    } catch (e) {
                                      print(e);
                                      throw e;
                                    } finally {
                                      setState(() {
                                        isLoad_balance = false;
                                      });
                                    }
                                    authProvider.user.balance
                                        ? authProvider.showAlert(
                                            context,
                                            cartProvider.balance.toString(),
                                            AlertType.success)
                                        : authProvider.showAlert(context,
                                            "Доступ запрещен", AlertType.error);
                                  },
                                  child: isLoad_balance
                                      ? CircularProgressIndicator()
                                      : Text(
                                          langs[authProvider.langIndex]
                                              ['balance'],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 20,
                                )
                              ])
                        : SizedBox(),
                    authProvider.isAuth
                        ? ProfileListItem(
                            isAuth,
                            const ChangeLanguageRoute(),
                            langs[authProvider.langIndex]['changeLangText'],
                            authProvider.user)
                        : SizedBox(),
                    authProvider.isAuth
                        ? ProfileListItem(
                            isAuth,
                            SettingsRoute(),
                            langs[authProvider.langIndex]['settings'],
                            authProvider.user)
                        : SizedBox(),
                    GestureDetector(
                      onTap: () async {
                        await context.read<AuthProvider>().logout(context);
                      },
                      child: Text(
                        langs[authProvider.langIndex]["logout"],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
