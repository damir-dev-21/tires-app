import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/services/languages.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

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
                    ListTile(
                      onTap: () {
                        authProvider.user.act_sverki
                            ? context.router.push(const CollationActRoute())
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      title: Text(langs[authProvider.langIndex]['akt_sverki']),
                    ),
                    ListTile(
                      onTap: () {
                        authProvider.user.act_sverki_detail
                            ? context.router
                                .push(const CollationActDetailRoute())
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      title: Text(
                          langs[authProvider.langIndex]['akt_sverki_detail']),
                    ),
                    ListTile(
                      onTap: () {
                        authProvider.user.bonus
                            ? context.router.push(const AccountBonusRoute())
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      title:
                          Text(langs[authProvider.langIndex]['account_bonus']),
                    ),
                    ListTile(
                      onTap: () {
                        authProvider.user.deficit
                            ? context.router.push(const DeficitRoute())
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      title:
                          Text(langs[authProvider.langIndex]['deficit_list']),
                    ),
                    ListTile(
                      onTap: () async {
                        await cartProvider.checkBalance(authProvider.user);
                        authProvider.user.balance
                            ? authProvider.showAlert(
                                context,
                                cartProvider.balance.toString(),
                                AlertType.success)
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      title: Text(langs[authProvider.langIndex]['balance']),
                    ),
                    ListTile(
                      onTap: () {
                        authProvider.user.subdivision_access
                            ? authProvider.showAllSubdivision(context)
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      title: Text(langs[authProvider.langIndex]['subdivision']),
                    ),
                    ListTile(
                      onTap: () async {
                        await cartProvider.checkRate();
                        authProvider.showAlert(
                            context,
                            "Курс валюты: " +
                                cartProvider.course_rate.toString(),
                            AlertType.success);
                      },
                      title: Text(langs[authProvider.langIndex]['exchange']),
                    ),
                    ListTile(
                      onTap: () {
                        context.router.push(OpinionRoute());
                      },
                      title: Text(langs[authProvider.langIndex]['review']),
                    ),
                    ListTile(
                      title: Text(langs[authProvider.langIndex]['settings']),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: ListTile(
                        onTap: () async {
                          await context.read<AuthProvider>().logout(context);
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
