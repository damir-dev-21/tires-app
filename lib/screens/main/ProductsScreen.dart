// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/models/Product.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/services/languages.dart';
import 'package:tires_app/services/notification_service.dart';
import 'package:tires_app/widgets/app_drawer.dart';

import 'package:tires_app/widgets/card_item.dart';
import '../../providers/products_provider.dart';
import '../../widgets/search_item_widget.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  bool isSearch = false;
  List<Product> products = [];
  List<Product> searchList = [];
  int rec = 2;
  late Image image1;
  late Image image2;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();

    image1 = Image.asset(
      "assets/Siyob Agromash-3.jpg",
      fit: BoxFit.cover,
    );

    // initializeService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image1.image, context);
  }

  void _runAnimation(status) async {
    while (status) {
      await _controller.forward();
      await _controller.reverse();
    }
  }

  @override
  void dispose() {
    super.dispose();
    isSearch = false;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: textColorDark),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            "assets/SiyobAgromash.png",
            fit: BoxFit.cover,
            width: 150,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await productProvider.getSynchronization(context);
                  await cartProvider.checkOrders();
                  if (authProvider.isAuth) {
                    await cartProvider.checkBalance(authProvider.user);
                  }
                  await cartProvider.checkRate();

                  if (productProvider.list_of_messages.length > 0) {
                    _runAnimation(true);
                  }
                },
                icon: Icon(Icons.sync_rounded)),
            Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: Tween(begin: 0.0, end: -.1)
                      .chain(CurveTween(curve: Curves.elasticIn))
                      .animate(_controller),
                  child: IconButton(
                      icon: Icon(Icons.notifications, color: textColorDark),
                      onPressed: () {
                        context.router.push(const NotificationRoute());
                      }),
                )
              ],
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await productProvider.getSynchronization(context);
            await cartProvider.checkOrders();
            await cartProvider.checkBalance(authProvider.user);
            await cartProvider.checkRate();

            if (productProvider.list_of_messages.length > 0) {
              _runAnimation(true);
            }
          },
          color: appColor,
          displacement: 20,
          child: SingleChildScrollView(
              child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.27,
                        child: TextField(
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          onChanged: (e) {
                            if (e == '') {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }

                            setState(() {
                              if (e != '') {
                                isSearch = true;
                              } else {
                                isSearch = false;
                              }
                            });

                            var text_list = e.toLowerCase().split(' ');
                            var prod = productProvider.products;

                            for (var element in text_list) {
                              prod = prod
                                  .where((e) =>
                                      e.name.toLowerCase().contains(element))
                                  .toList();
                            }
                            setState(() {
                              searchList = prod;
                            });
                          },
                          cursorColor: textColorDark,
                          decoration: InputDecoration(
                            focusColor: appColor,
                            labelStyle: const TextStyle(color: textColorDark),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: textColorDark),
                                borderRadius: BorderRadius.circular(20)),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            labelText: langs[authProvider.langIndex]
                                ['search-text'],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            context.router.push(FilterRoute());
                          },
                          icon: const Icon(
                            Icons.filter_alt_sharp,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
                isSearch
                    ? Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: Row(children: [
                              Expanded(
                                child: ListView.builder(
                                    itemCount: searchList.length,
                                    itemBuilder: (ctx, index) {
                                      final product = searchList[index];
                                      return SearchItemWidget(
                                        product: product,
                                        type: 'order',
                                      );
                                    }),
                              ),
                            ]),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(
                              langs[authProvider.langIndex]['popular-products'],
                              style: const TextStyle(
                                  color: textColorDark, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                              height: 300,
                              child: context.read<ProductProvider>().isLoad
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: appColor),
                                    )
                                  : Column(
                                      children: [
                                        Expanded(
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: productProvider
                                                    .recomendation.length,
                                                itemBuilder: (ctx, index) {
                                                  final Product product =
                                                      context
                                                          .read<
                                                              ProductProvider>()
                                                          .recomendation[index];
                                                  return CardItem(
                                                      product: product);
                                                })),
                                      ],
                                    ))
                        ],
                      ),
                isSearch
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 30),
                            child: Text(
                              langs[authProvider.langIndex]['new-products'],
                              style: const TextStyle(
                                  color: textColorDark, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                              height: 300,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  context.read<ProductProvider>().isLoad
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: appColor,
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: context
                                                  .read<ProductProvider>()
                                                  .newProducts
                                                  .length,
                                              itemBuilder: (ctx, index) {
                                                final Product product = context
                                                    .read<ProductProvider>()
                                                    .newProducts[index];
                                                return CardItem(
                                                    product: product);
                                              }))
                                ],
                              ))
                        ],
                      ),
              ],
            ),
          )),
        ),
        drawer: authProvider.isAuth ? const AppDrawer() : null);
  }
}
