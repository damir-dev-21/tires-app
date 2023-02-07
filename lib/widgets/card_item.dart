import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/models/Product.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/services/languages.dart';

import '../constants/colors.dart';

class CardItem extends StatefulWidget {
  const CardItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool countVisible = false;
  bool setInput = false;
  final TextEditingController _controller = TextEditingController();
  final focus = FocusNode();
  var idx = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    focus.unfocus();
  }

  void _manageCountVisible(bool value) {
    setState(() {
      countVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<ProductProvider>().products.firstWhere(
          (element) => element.guid == widget.product.guid,
        );
    _controller.text = product.currentCount.toString();
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
    // _controller.selection = TextSelection.fromPosition(
    //     TextPosition(offset: _controller.text.length));
    return Card(
      elevation: 2,
      shadowColor: Colors.grey,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.2,
        height: 300,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: () {
            context.router.push(DetailRoute(
                product: widget.product,
                manageCountVisible: _manageCountVisible,
                isaddition: false));
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             DetailScreen(product: widget.product)));
            // setState(() {});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Image.asset(
                  widget.product.image,
                  width: 80,
                  height: 150,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: 180,
                      child: Text(
                        widget.product.name,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      widget.product.category,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.price.toString() +
                              langs[context.read<AuthProvider>().langIndex]
                                  ['currency'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ]),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          countVisible = true;
                        });
                        context.read<CartProvider>().addToCart(widget.product);
                      },
                      child: !countVisible
                          ? SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(appColor)),
                                  onPressed: () {
                                    context
                                        .read<CartProvider>()
                                        .changeCurrentCount("INC", product);
                                    context
                                        .read<CartProvider>()
                                        .addToCart(product);
                                    setState(() {
                                      countVisible = true;
                                      _controller.text =
                                          product.currentCount.toString();
                                    });
                                  },
                                  child: Text(langs[context
                                      .read<AuthProvider>()
                                      .langIndex]['add-product'])),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  HoldDetector(
                                    onHold: () {
                                      context
                                          .read<CartProvider>()
                                          .changeCurrentCount("DEC", product);
                                      context
                                          .read<CartProvider>()
                                          .addToCart(product);
                                      var currentText =
                                          int.parse(_controller.text);

                                      setState(() {
                                        if (currentText > 1) {
                                          _controller.text =
                                              (int.parse(_controller.text) - 1)
                                                  .toString();
                                        } else {
                                          setState(() {
                                            countVisible = false;
                                          });
                                          context
                                              .read<CartProvider>()
                                              .deleteFromCart(product);
                                        }
                                      });
                                    },
                                    onTap: () {
                                      context
                                          .read<CartProvider>()
                                          .changeCurrentCount("DEC", product);
                                      context
                                          .read<CartProvider>()
                                          .addToCart(product);
                                      var currentText =
                                          int.parse(_controller.text);

                                      setState(() {
                                        if (currentText > 1) {
                                          _controller.text =
                                              (int.parse(_controller.text) - 1)
                                                  .toString();
                                        } else {
                                          setState(() {
                                            countVisible = false;
                                          });
                                          context
                                              .read<CartProvider>()
                                              .deleteFromCart(product);
                                        }
                                      });
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: textColorLight,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Text(
                                          "-",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                  Flexible(
                                    child: SizedBox(
                                      height: 38,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: TextFormField(
                                            controller: _controller,
                                            focusNode: focus,
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            onChanged: (e) {
                                              if (int.parse(e) < 1 ||
                                                  e.isEmpty) {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                              }
                                              if (e == '') {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                              }
                                              if (int.parse(e) != 0 &&
                                                  int.parse(e) > 0) {
                                                context
                                                    .read<CartProvider>()
                                                    .addProductToCart(
                                                        int.parse(e), product);
                                                context
                                                    .read<CartProvider>()
                                                    .changeCurrentCountFromInput(
                                                        int.parse(e), product);

                                                _controller.text = product
                                                    .currentCount
                                                    .toString();
                                                _controller.selection =
                                                    TextSelection.fromPosition(
                                                        TextPosition(
                                                            offset: _controller
                                                                .text.length));
                                              }
                                            },
                                            onEditingComplete: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                floatingLabelAlignment:
                                                    FloatingLabelAlignment
                                                        .center,
                                                border: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 220, 220, 220))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 220, 220, 220))),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide: BorderSide(color: Color.fromARGB(255, 220, 220, 220))),
                                                errorBorder: InputBorder.none,
                                                disabledBorder: InputBorder.none,
                                                label: Center(
                                                  child: Text(product
                                                      .currentCount
                                                      .toString()),
                                                ))),
                                      ),
                                    ),
                                  ),
                                  HoldDetector(
                                    onHold: () {
                                      context
                                          .read<CartProvider>()
                                          .changeCurrentCount(
                                              "INC", widget.product);
                                      context
                                          .read<CartProvider>()
                                          .addToCart(widget.product);

                                      setState(() {
                                        _controller.text =
                                            (int.parse(_controller.text) + 1)
                                                .toString();
                                      });
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: appColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Text(
                                          "+",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                ],
                              )),
                            ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
