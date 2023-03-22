import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/services/languages.dart';
import 'package:tires_app/widgets/notifications.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    fToast.removeCustomToast();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        context.router.push(const ProfileRoute());
                      },
                      title: Text(langs[authProvider.langIndex]['profile_bar']),
                    ),
                    ListTile(
                      onTap: () {
                        context.router.push(const OrdersRoute());
                      },
                      title: Text(langs[authProvider.langIndex]['myOrders']),
                    ),
                    authProvider.isAuth
                        ? ListTile(
                            onTap: () {
                              if (!authProvider.isAuth) {
                                showToastMessage_auth(fToast, context,
                                    'Необходимо войти в приложение');
                                return;
                              }
                              authProvider.user.act_sverki
                                  ? context.router
                                      .push(const CollationActRoute())
                                  : authProvider.showAlert(context,
                                      "Доступ запрещен", AlertType.error);
                            },
                            title: Text(
                                langs[authProvider.langIndex]['akt_sverki']),
                          )
                        : SizedBox(),
                    authProvider.isAuth
                        ? ListTile(
                            onTap: () {
                              if (!authProvider.isAuth) {
                                showToastMessage_auth(fToast, context,
                                    'Необходимо войти в приложение');
                                return;
                              }
                              authProvider.user.act_sverki_detail
                                  ? context.router
                                      .push(const CollationActDetailRoute())
                                  : authProvider.showAlert(context,
                                      "Доступ запрещен", AlertType.error);
                            },
                            title: Text(langs[authProvider.langIndex]
                                ['akt_sverki_detail']),
                          )
                        : SizedBox(),
                    authProvider.isAuth
                        ? ListTile(
                            onTap: () {
                              if (!authProvider.isAuth) {
                                showToastMessage_auth(fToast, context,
                                    'Необходимо войти в приложение');
                                return;
                              }
                              authProvider.user.bonus
                                  ? context.router
                                      .push(const AccountBonusRoute())
                                  : authProvider.showAlert(context,
                                      "Доступ запрещен", AlertType.error);
                            },
                            title: Text(
                                langs[authProvider.langIndex]['account_bonus']),
                          )
                        : SizedBox(),
                    authProvider.isAuth
                        ? ListTile(
                            onTap: () {
                              if (!authProvider.isAuth) {
                                showToastMessage_auth(fToast, context,
                                    'Необходимо войти в приложение');
                                return;
                              }
                              authProvider.user.deficit
                                  ? context.router.push(const DeficitRoute())
                                  : authProvider.showAlert(context,
                                      "Доступ запрещен", AlertType.error);
                            },
                            title: Text(
                                langs[authProvider.langIndex]['deficit_list']),
                          )
                        : SizedBox(),
                    authProvider.isAuth
                        ? ListTile(
                            onTap: () async {
                              if (!authProvider.isAuth) {
                                showToastMessage_auth(fToast, context,
                                    'Необходимо войти в приложение');
                                return;
                              }
                              await cartProvider
                                  .checkBalance(authProvider.user);
                              authProvider.user.balance
                                  ? authProvider.showAlert(
                                      context,
                                      cartProvider.balance.toString(),
                                      AlertType.success)
                                  : authProvider.showAlert(context,
                                      "Доступ запрещен", AlertType.error);
                            },
                            title:
                                Text(langs[authProvider.langIndex]['balance']),
                          )
                        : SizedBox(),
                    authProvider.isAuth
                        ? ListTile(
                            onTap: () {
                              if (!authProvider.isAuth) {
                                showToastMessage_auth(fToast, context,
                                    'Необходимо войти в приложение');
                                return;
                              }
                              authProvider.user.subdivision_access
                                  ? authProvider.showAllSubdivision(context)
                                  : authProvider.showAlert(context,
                                      "Доступ запрещен", AlertType.error);
                            },
                            title: Text(
                                langs[authProvider.langIndex]['subdivision']),
                          )
                        : SizedBox(),
                    authProvider.isAuth
                        ? ListTile(
                            onTap: () async {
                              if (!authProvider.isAuth) {
                                showToastMessage_auth(fToast, context,
                                    'Необходимо войти в приложение');
                                return;
                              }
                              await cartProvider.checkRate();
                              authProvider.showAlert(
                                  context,
                                  "Курс валюты: " +
                                      cartProvider.course_rate.toString(),
                                  AlertType.success);
                            },
                            title:
                                Text(langs[authProvider.langIndex]['exchange']),
                          )
                        : SizedBox(),
                    ListTile(
                      onTap: () {
                        context.router.push(OpinionRoute());
                      },
                      title: Text(langs[authProvider.langIndex]['review']),
                    ),
                    authProvider.isAuth
                        ? ListTile(
                            onTap: () {
                              if (!authProvider.isAuth) {
                                showToastMessage_auth(fToast, context,
                                    'Необходимо войти в приложение');
                                return;
                              }
                              context.router.push(SettingsRoute());
                            },
                            title:
                                Text(langs[authProvider.langIndex]['settings']),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: ListTile(
                        onTap: () async {
                          await context.read<AuthProvider>().logout(context);
                          context.read<CartProvider>().clearAllCart();
                          context.read<CartProvider>().clearAdditionCart();
                        },
                        title: Text(langs[authProvider.langIndex]['logout']),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
