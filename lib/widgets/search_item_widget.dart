import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/models/Product.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/routes/router.dart';

import '../constants/colors.dart';
import '../providers/cart_provider.dart';

class SearchItemWidget extends StatefulWidget {
  const SearchItemWidget({Key? key, required this.product, required this.type})
      : super(key: key);
  final Product product;
  final String type;
  @override
  State<SearchItemWidget> createState() => _SearchItemWidgetState();
}

class _SearchItemWidgetState extends State<SearchItemWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = widget.product.currentCount == 0
        ? ''
        : widget.product.currentCount.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _manage(value) {
    if (value) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<ProductProvider>().products.firstWhere(
          (element) => element.guid == widget.product.guid,
        );
    _controller.text =
        product.currentCount == 0 ? '' : product.currentCount.toString();
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
    return GestureDetector(
      onTap: () {
        context.router.push(DetailRoute(
            product: widget.product,
            manageCountVisible: _manage,
            isaddition: widget.type == 'additional' ? true : false));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          leading: Image.asset(
            widget.product.image,
            fit: BoxFit.cover,
            height: 250,
          ),
          title: Text(
            widget.product.name,
            style: const TextStyle(fontSize: 14),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.product.category,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                widget.product.count < 100 && widget.product.count != 0
                    ? "Остаток: " + widget.product.count.toString()
                    : widget.product.count <= 0
                        ? "Остаток:  Нету"
                        : "Остаток: Много",
                style: const TextStyle(fontSize: 12),
              )
            ]),
          ),
          trailing: SizedBox(
            width: 135,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HoldDetector(
                  onHold: () {
                    var currentText = int.parse(_controller.text);

                    context
                        .read<CartProvider>()
                        .changeCurrentCount("DEC", product);
                    if (widget.type == 'additional') {
                      context.read<CartProvider>().addToAdditionalCart(product);
                    } else {
                      context.read<CartProvider>().addToCart(product);
                    }
                    context.read<CartProvider>().changeTotalPrice();
                    context
                        .read<CartProvider>()
                        .changeTotalPriceAdditionalCart();

                    setState(() {
                      if (currentText > 1) {
                        _controller.text =
                            (int.parse(_controller.text) - 1).toString();
                      } else {
                        context
                            .read<CartProvider>()
                            .deleteFromCart(widget.product);
                        context
                            .read<CartProvider>()
                            .deleteFromAdditionCart(widget.product);
                      }
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(
                          color: textColorLight,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(
                        "-",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Flexible(
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                        style: const TextStyle(fontSize: 15),
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (e) {
                          if (int.parse(e) != 0) {
                            if (widget.type == 'additional') {
                              context
                                  .read<CartProvider>()
                                  .addProductToAdditionalCart(
                                      int.parse(e), product);
                            } else {
                              context
                                  .read<CartProvider>()
                                  .addProductToCart(int.parse(e), product);
                              // context.read<CartProvider>().addToCart(product);
                            }
                            // context
                            //     .read<CartProvider>()
                            //     .addProductToCart(int.parse(e), product);
                            // context
                            //     .read<CartProvider>()
                            //     .changeCurrentCountFromInput(
                            //         int.parse(e), product);
                          } else {
                            context
                                .read<CartProvider>()
                                .deleteFromCart(widget.product);
                            context
                                .read<CartProvider>()
                                .deleteFromAdditionCart(widget.product);

                            context.read<CartProvider>().changeTotalPrice();
                            context
                                .read<CartProvider>()
                                .changeTotalPriceAdditionalCart();

                            context
                                .read<CartProvider>()
                                .changeCurrentCountFromInput(0, product);
                            setState(() {});
                          }
                          _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: _controller.text.length));
                          setState(() {});
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: product.currentCount == 0
                                ? const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 0.5))
                                : const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            label: Center(
                              child: Text(product.currentCount == 0
                                  ? ' '
                                  : product.currentCount.toString()),
                            ))),
                  ),
                ),
                HoldDetector(
                  onHold: () {
                    context
                        .read<CartProvider>()
                        .changeCurrentCount("INC", widget.product);

                    if (widget.type == 'additional') {
                      context.read<CartProvider>().addToAdditionalCart(product);
                    } else {
                      context.read<CartProvider>().addToCart(widget.product);
                    }
                    context.read<CartProvider>().changeTotalPrice();
                    context
                        .read<CartProvider>()
                        .changeTotalPriceAdditionalCart();
                    setState(() {
                      if (_controller.text == '') {
                        _controller.text = product.currentCount.toString();
                      } else {
                        var currentText = int.parse(_controller.text);

                        _controller.text = (currentText + 1).toString();
                      }
                    });
                    setState(() {});
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(
                          color: widget.type == 'additional'
                              ? Theme.of(context).primaryColor
                              : appColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(
                        "+",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
