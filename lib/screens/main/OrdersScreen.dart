import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/services/languages.dart';
import 'package:tires_app/widgets/order_item_widget.dart';

import '../../models/Order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        centerTitle: true,
        title: Image.asset(
          "assets/whiteLogo.png",
          height: 40,
        ),
        actions: [
          isLoad
              ? const SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        isLoad = true;
                      });
                      await productProvider.getNotifications();
                      await cartProvider.checkOrders();
                    } catch (e) {
                      print(e);
                      throw e;
                    } finally {
                      setState(() {
                        isLoad = false;
                      });
                    }
                  },
                  icon: const Icon(Icons.sync))
        ],
      ),
      body: !authProvider.isAuth
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Необходимо войти в приложение',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.router.push(LoginRoute());
                      },
                      child: Text("Войти"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(appColor)),
                    )
                  ],
                ),
              ),
            )
          : Container(
              child: context.read<CartProvider>().orders.isEmpty
                  ? Center(
                      child: Text(langs[authProvider.langIndex]['orders-none']),
                    )
                  : Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                                itemCount:
                                    context.read<CartProvider>().orders.length,
                                itemBuilder: (ctx, index) {
                                  final order = context
                                      .read<CartProvider>()
                                      .orders[index];
                                  var statusOrder = order.status ==
                                          StatusOrder.newOrder.name
                                      ? "Новый"
                                      : order.status ==
                                              StatusOrder.onTheWay.name
                                          ? "В пути"
                                          : order.status ==
                                                  StatusOrder.shipment.name
                                              ? "Отгрузка"
                                              : order.status ==
                                                      StatusOrder.confirmed.name
                                                  ? 'Подтвержден'
                                                  : order.status ==
                                                          StatusOrder
                                                              .unconfirmed.name
                                                      ? "Не подтвержден"
                                                      : "Отказано";

                                  return OrderItem(
                                      order: order, statusOrder: statusOrder);
                                }))
                      ],
                    ),
            ),
    );
  }
}
