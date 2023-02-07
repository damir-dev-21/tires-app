import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/models/Order.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/balance_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';

import '../../services/languages.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({Key? key, required this.order}) : super(key: key);
  final Order order;
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String statusOrder = "";
  @override
  void initState() {
    super.initState();
    statusOrder = widget.order.status == StatusOrder.newOrder.name
        ? "Новый"
        : widget.order.status == StatusOrder.onTheWay.name
            ? "В пути"
            : widget.order.status == StatusOrder.shipment.name
                ? "Отгрузка"
                : widget.order.status == StatusOrder.confirmed.name
                    ? 'Подтвержден'
                    : widget.order.status == StatusOrder.unconfirmed.name
                        ? "Не подтвержден"
                        : "Отказано";
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    final BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context);
    void openFile(file) async {
      if (file == null) return;

      await OpenFile.open(file.path);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        centerTitle: false,
        title: Text(
          langs[context.read<AuthProvider>().langIndex]['order-with-number'] +
              widget.order.number.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        leading: IconButton(
            onPressed: () {
              context.router.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        actions: [
          Center(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.black45),
                  child: Text(statusOrder))),
          widget.order.status == StatusOrder.unconfirmed.name
              ? IconButton(
                  onPressed: () async {
                    String base64_string = await cartProvider
                        .getUnConfirmList(widget.order.userId);
                    print(base64_string);
                    Uint8List bytes = base64.decode(base64_string);
                    await balanceProvider.checkDocumentFolder();
                    String dir =
                        balanceProvider.directory!.path + '/' + 'List' + ".pdf";
                    File file = File(dir);
                    if (!file.existsSync()) file.create();
                    await file.writeAsBytes(bytes);
                    var balanceFile = file;

                    openFile(balanceFile);
                  },
                  icon: Icon(Icons.list_alt_rounded),
                )
              : SizedBox(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: [
      //     ElevatedButton(
      //       style: ButtonStyle(
      //           backgroundColor: MaterialStateProperty.all(appColor)),
      //       onPressed: () {
      //         print(widget.order.toMap());
      //       },
      //       child: const Text('Заказать'),
      //     ),
      //   ],
      // ),
      floatingActionButton: widget.order.status ==
                  StatusOrder.unconfirmed.name &&
              widget.order.is_not_confirm != true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton.extended(
                  backgroundColor: appColor,
                  onPressed: () async {
                    bool status = await cartProvider.sendConfirmation(
                        context, widget.order.uuid_sale, widget.order);
                    print(status);
                    print(widget.order.uuid_sale);

                    setState(() {});
                  },
                  label: Text("Подтвердить"),
                ),
                FloatingActionButton.extended(
                  backgroundColor: textColorLight,
                  onPressed: () async {
                    await cartProvider.changeIsNotConfirmed(widget.order, true);
                    // print(widget.order.is_not_confirm);
                    // setState(() {});
                  },
                  label: Text("Не подтверждать"),
                ),
              ],
            )
          : widget.order.status == StatusOrder.newOrder.name
              ? FloatingActionButton.extended(
                  backgroundColor: textColorLight,
                  onPressed: () async {
                    await cartProvider.sendRejectOrder(
                        widget.order.userId, widget.order);
                    print(widget.order.userId);
                    setState(() {});
                  },
                  label: Text("Отклонить заказ"),
                )
              : null,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (ctx, index) {
                    final product = widget.order.products[index];
                    return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Image.asset(
                                      product.image,
                                      width: 50,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 150,
                                          child: Text(
                                            product.name,
                                            maxLines: 1,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        product.category,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        product.producer,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        product.typesize,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(product.price.toString() +
                                    langs[context
                                        .read<AuthProvider>()
                                        .langIndex]['currency']),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(langs[context
                                        .read<AuthProvider>()
                                        .langIndex]['order-count'] +
                                    product.currentCount.toString()),
                              ],
                            )
                          ],
                        ));
                  })),
          widget.order.addition_products.isNotEmpty
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, bottom: 5, top: 5),
                        child: Text(
                          "Доп заказ",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      height: 1,
                      child: Container(
                        color: textColorLight,
                      ),
                    )
                  ],
                )
              : SizedBox(),
          widget.order.addition_products.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: widget.order.addition_products.length,
                      itemBuilder: (ctx, index) {
                        final product = widget.order.addition_products[index];
                        return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Image.asset(
                                          product.image,
                                          width: 50,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: 150,
                                              child: Text(
                                                product.name,
                                                maxLines: 1,
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            product.category,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            product.producer,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            product.typesize,
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(product.price.toString() +
                                        langs[context
                                            .read<AuthProvider>()
                                            .langIndex]['currency']),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(langs[context
                                            .read<AuthProvider>()
                                            .langIndex]['order-count'] +
                                        product.currentCount.toString()),
                                  ],
                                )
                              ],
                            ));
                      }))
              : SizedBox()
        ],
      )),
    );
  }
}
