// ignore_for_file: file_names, non_constant_identifier_names

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/models/Product.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/screens/AdditionOrderListScreen.dart';
import 'package:tires_app/screens/AdditionOrderScreen.dart';
import 'package:tires_app/services/background_fetch.dart';
import 'package:tires_app/widgets/notifications.dart';

import '../../services/languages.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double minHeightOfSheet = 0;
  bool status_slide = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  void _manageCountVisible(bool value) {}

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appColor,
        centerTitle: true,
        title: Image.asset(
          "assets/whiteLogo.png",
          height: 40,
        ),
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.circular(15),
        minHeight: minHeightOfSheet,
        color: Colors.white,
        isDraggable: false,
        maxHeight: 800,
        panel: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: cartProvider.imperfective_answer.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text(
                                      "${langs[authProvider.langIndex]['workload_products']} ${cartProvider.imperfective_text}",
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                          physics: ScrollPhysics(),
                                          itemCount: cartProvider
                                              .imperfective_answer.length,
                                          itemBuilder: (ctx, i) {
                                            final Map<String, dynamic> product =
                                                cartProvider
                                                    .imperfective_answer[i];
                                            return GestureDetector(
                                              onTap: () {
                                                context.router.push(DetailRoute(
                                                    product: product['product'],
                                                    manageCountVisible:
                                                        _manageCountVisible,
                                                    isaddition: false));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      product['product']
                                                          .name
                                                          .replaceAll(
                                                              RegExp("\\s+"),
                                                              " "),
                                                    ),
                                                    Text(product['count']
                                                        .toString())
                                                  ],
                                                ),
                                              ),
                                            );
                                          }))
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      child: cartProvider.popular_answer.isEmpty
                          ? const SizedBox()
                          : Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text(
                                      langs[authProvider.langIndex]
                                          ['popular_products'],
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 120,
                                      child: ListView.builder(
                                          itemCount: cartProvider
                                              .popular_answer.length,
                                          itemBuilder: (ctx, i) {
                                            final Map<String, dynamic> product =
                                                cartProvider.popular_answer[i];
                                            return GestureDetector(
                                              onTap: () {
                                                context.router.push(DetailRoute(
                                                    product: product['product'],
                                                    manageCountVisible:
                                                        _manageCountVisible,
                                                    isaddition: false));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 250,
                                                      child: Text(
                                                        product['product']
                                                            .name
                                                            .replaceAll(
                                                                RegExp("\\s+"),
                                                                " "),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    Text(product['count']
                                                        .toString())
                                                  ],
                                                ),
                                              ),
                                            );
                                          }))
                                ],
                              ),
                            ),
                    ),
                    SizedBox(
                      child: cartProvider.remainders_answer.isEmpty
                          ? const SizedBox()
                          : Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text(
                                      langs[authProvider.langIndex]
                                          ['warehouse_missed'],
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                          itemCount: cartProvider
                                              .remainders_answer.length,
                                          itemBuilder: (ctx, i) {
                                            final Map<String, dynamic> product =
                                                cartProvider
                                                    .remainders_answer[i];
                                            return GestureDetector(
                                              onTap: () {
                                                context.router.push(DetailRoute(
                                                    product: product['product'],
                                                    manageCountVisible:
                                                        _manageCountVisible,
                                                    isaddition: false));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 250,
                                                      child: Text(
                                                        product['product']
                                                            .name
                                                            .replaceAll(
                                                                RegExp("\\s+"),
                                                                " "),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    Text(product['no_enough']
                                                        .toString())
                                                  ],
                                                ),
                                              ),
                                            );
                                          }))
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: status_slide || minHeightOfSheet == 800
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            minHeightOfSheet = 50;
                            status_slide = !status_slide;
                          });
                        },
                        icon: const Icon(Icons.close))
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.center,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  minHeightOfSheet = 800;
                                  status_slide = !status_slide;
                                });
                              },
                              icon: const Icon(Icons.keyboard_double_arrow_up)),
                        ),
                      ))
          ],
        ),
        body: SafeArea(
            child: !authProvider.isAuth
                ? Container(
                    margin: const EdgeInsets.only(bottom: 200),
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
                                backgroundColor:
                                    MaterialStateProperty.all(appColor)),
                          )
                        ],
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: appColor),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 240, 240, 240),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30))),
                        child: cartProvider.cart.isEmpty
                            ? Center(
                                child: Text(langs[authProvider.langIndex]
                                    ['empty_cart']),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          langs[authProvider.langIndex]
                                              ['products_in_cart'],
                                          style: const TextStyle(
                                              color: textColorDark,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        cartProvider.additional_cart.isEmpty
                                            ? const SizedBox()
                                            : ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(_createRoute());
                                                },
                                                icon: const Icon(
                                                    Icons.arrow_right),
                                                label: Text(
                                                  "Доп заказ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                )),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 20),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2.2,
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: ListView.builder(
                                                  itemCount:
                                                      cartProvider.cart.length,
                                                  itemBuilder: (ctx, index) {
                                                    final Product product =
                                                        cartProvider
                                                            .cart[index];
                                                    return Stack(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            context.router.push(
                                                                DetailRoute(
                                                                    product:
                                                                        product,
                                                                    manageCountVisible:
                                                                        _manageCountVisible,
                                                                    isaddition:
                                                                        false));
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 10),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            height: 110,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  child: Image.asset(
                                                                      product
                                                                          .image,
                                                                      width:
                                                                          50),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          150,
                                                                      child:
                                                                          Text(
                                                                        product
                                                                            .name,
                                                                        maxLines:
                                                                            1,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                13),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        product.price.toString() +
                                                                            langs[authProvider.langIndex]['currency'],
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 14),
                                                                      ),
                                                                    ),
                                                                    RatingBar
                                                                        .builder(
                                                                      initialRating:
                                                                          product
                                                                              .priority,
                                                                      minRating:
                                                                          1,
                                                                      itemSize:
                                                                          14,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      allowHalfRating:
                                                                          false,
                                                                      itemCount:
                                                                          5,
                                                                      itemPadding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              1.0),
                                                                      itemBuilder:
                                                                          (context, _) =>
                                                                              const Icon(
                                                                        Icons
                                                                            .circle,
                                                                        color:
                                                                            appColor,
                                                                      ),
                                                                      onRatingUpdate:
                                                                          (rating) {
                                                                        cartProvider.changePriorityProduct(
                                                                            rating,
                                                                            product);
                                                                        print(
                                                                            rating);
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          12.0),
                                                                  child: Row(
                                                                    children: [
                                                                      HoldDetector(
                                                                        onHold:
                                                                            () {
                                                                          context.read<CartProvider>().changeCurrentCount(
                                                                              "DEC",
                                                                              product);
                                                                        },
                                                                        child: Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: textColorLight),
                                                                            child: const Text(
                                                                              "-",
                                                                              style: TextStyle(fontSize: 16, color: Colors.white),
                                                                            )),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 8),
                                                                        child: Text(product
                                                                            .currentCount
                                                                            .toString()),
                                                                      ),
                                                                      HoldDetector(
                                                                        onHold:
                                                                            () {
                                                                          context.read<CartProvider>().changeCurrentCount(
                                                                              "INC",
                                                                              product);
                                                                        },
                                                                        child: Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: appColor),
                                                                            child: const Text(
                                                                              "+",
                                                                              style: TextStyle(fontSize: 16, color: Colors.white),
                                                                            )),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                            top: 2,
                                                            right: 5,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                context
                                                                    .read<
                                                                        CartProvider>()
                                                                    .deleteFromCart(
                                                                        product);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 20,
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                      ],
                                                    );
                                                  })),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              langs[authProvider.langIndex]
                                                  ['total'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              context
                                                  .read<CartProvider>()
                                                  .total
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              langs[authProvider.langIndex]
                                                  ['order-count'],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              context
                                                  .read<CartProvider>()
                                                  .total_count
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                        authProvider.isAddition
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    langs[authProvider
                                                            .langIndex][
                                                        'order-count_addition'],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    context
                                                        .read<CartProvider>()
                                                        .total_count_additional
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  )
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    cartProvider.isLoad
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    height: 40,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .resolveWith(
                                                                        (states) =>
                                                                            appColor)),
                                                        onPressed: () async {
                                                          await authProvider
                                                              .checkConnection();
                                                          if (authProvider
                                                                  .hasConnect ==
                                                              false) {
                                                            showToastConnection(
                                                                fToast);
                                                            // cartProvider.setOrderToDb();
                                                          } else {
                                                            // await context
                                                            //     .read<CartProvider>()
                                                            //     .showAllClient(context);
                                                            bool status = await cartProvider
                                                                .checkOrder(
                                                                    context,
                                                                    productProvider
                                                                        .products,
                                                                    authProvider);
                                                            bool haslimit = context
                                                                .read<
                                                                    CartProvider>()
                                                                .haslimit;
                                                            setState(() {
                                                              if (haslimit ==
                                                                      true ||
                                                                  status ==
                                                                      false) {
                                                                minHeightOfSheet =
                                                                    800;
                                                                status_slide =
                                                                    !status_slide;
                                                              } else {
                                                                minHeightOfSheet =
                                                                    0;
                                                              }
                                                            });
                                                          }
                                                        },
                                                        child: Text(
                                                          langs[authProvider
                                                                  .langIndex]
                                                              ['set_order'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16),
                                                        )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    height: 40,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                                                                authProvider
                                                                        .isAddition
                                                                    ? Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                    : Colors
                                                                        .grey)),
                                                        onPressed: () {
                                                          authProvider
                                                                  .isAddition
                                                              ? context.router.push(
                                                                  const AdditionOrderRoute())
                                                              : authProvider
                                                                  .showAlert(
                                                                      context,
                                                                      "Доступ запрещен",
                                                                      AlertType
                                                                          .error);
                                                        },
                                                        child: const Text(
                                                          "Доп заказ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              ),
                      )
                    ],
                  )),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AdditionOrderListScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
