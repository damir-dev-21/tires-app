import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/routes/router.dart';

import '../constants/colors.dart';
import '../models/Order.dart';
import '../services/languages.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key, required this.order, required this.statusOrder})
      : super(key: key);
  final Order order;
  final String statusOrder;
  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  // String statusOrder = "";
  @override
  void initState() {
    super.initState();
    // statusOrder = widget.order.status == StatusOrder.newOrder.name
    //     ? "Новый"
    //     : widget.order.status == StatusOrder.onTheWay.name
    //         ? "В пути"
    //         : widget.order.status == StatusOrder.shipment.name
    //             ? "Отгрузка"
    //             : widget.order.status == StatusOrder.confirmed.name
    //                 ? 'Подтвержден'
    //                 : widget.order.status == StatusOrder.unconfirmed.name
    //                     ? "Не подтвержден"
    //                     : "Отказано";
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Stack(
            children: [
              ListTile(
                onTap: () {
                  context.router.push(OrderDetailRoute(order: widget.order));
                },
                contentPadding: const EdgeInsets.all(15),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        langs[context.read<AuthProvider>().langIndex]
                                ['order-with-number'] +
                            widget.order.number.toString() +
                            " \n" +
                            widget.order.date,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            context.router
                                .push(OrderDetailRoute(order: widget.order));
                          },
                          child: Row(
                            children: [
                              Text(
                                langs[context.read<AuthProvider>().langIndex]
                                    ['detail'],
                                style: const TextStyle(
                                    color: textColorLight, fontSize: 12),
                              ),
                              Icon(
                                _expanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: textColorDark,
                                size: 18,
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
                trailing: Text(widget.order.total.toString()),
              ),
              Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                      onTap: () {
                        cartProvider.deleteOrder(widget.order);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: widget.statusOrder == "Новый"
                                ? Colors.redAccent
                                : widget.statusOrder == "В пути"
                                    ? Colors.yellowAccent
                                    : widget.statusOrder == "Отгрузка"
                                        ? Colors.greenAccent
                                        : Colors.red),
                        child: Text(
                          widget.statusOrder,
                          style: TextStyle(
                              fontSize: 12,
                              color: widget.statusOrder == "В пути"
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      )))
            ],
          ),
        ],
      ),
    );
  }
}
