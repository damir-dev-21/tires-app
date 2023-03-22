import 'package:flutter/material.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/models/Product/Product.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/services/languages.dart';

import '../../constants/colors.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen(
      {Key? key,
      required this.product,
      required this.manageCountVisible,
      required this.isaddition})
      : super(key: key);

  final Product product;
  final void Function(bool) manageCountVisible;
  final bool isaddition;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.product.currentCount.toString();
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                  icon: const Icon(Icons.notifications, color: textColorDark),
                  onPressed: () {}),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    HoldDetector(
                      onHold: () {
                        context
                            .read<CartProvider>()
                            .changeCurrentCount("DEC", widget.product);
                        if (widget.isaddition) {
                          context
                              .read<CartProvider>()
                              .addToAdditionalCart(widget.product);
                        } else {
                          context
                              .read<CartProvider>()
                              .addToCart(widget.product);
                        }
                        var currentText = int.parse(_controller.text);

                        context.read<CartProvider>().changeTotalPrice();
                        context
                            .read<CartProvider>()
                            .changeTotalPriceAdditionalCart();

                        setState(() {
                          if (currentText > 1) {
                            _controller.text =
                                (int.parse(_controller.text) - 1).toString();
                            widget.manageCountVisible(true);
                          } else {
                            _controller.text = (0).toString();
                            widget.manageCountVisible(true);
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
                              horizontal: 20, vertical: 17),
                          decoration: BoxDecoration(
                              color: textColorLight,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            "-",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Flexible(
                      child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (e) {
                            if (int.parse(e) != 0 && int.parse(e) > 0) {
                              if (widget.isaddition) {
                                context
                                    .read<CartProvider>()
                                    .addProductToAdditionalCart(
                                        int.parse(e), widget.product);
                              } else {
                                context.read<CartProvider>().addProductToCart(
                                    int.parse(e), widget.product);
                              }
                              context
                                  .read<CartProvider>()
                                  .changeCurrentCountFromInput(
                                      int.parse(e), widget.product);
                              context.read<CartProvider>().changeTotalPrice();
                              context
                                  .read<CartProvider>()
                                  .changeTotalPriceAdditionalCart();
                              widget.manageCountVisible(true);
                            } else {
                              context
                                  .read<CartProvider>()
                                  .deleteFromCart(widget.product);
                              context
                                  .read<CartProvider>()
                                  .deleteFromAdditionCart(widget.product);
                            }
                            _controller.selection = TextSelection.fromPosition(
                                TextPosition(offset: _controller.text.length));
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              label: Center(
                                child: Text(
                                    widget.product.currentCount.toString()),
                              ))),
                    ),
                    HoldDetector(
                      onHold: () {
                        context
                            .read<CartProvider>()
                            .changeCurrentCount("INC", widget.product);
                        if (widget.isaddition) {
                          context
                              .read<CartProvider>()
                              .addToAdditionalCart(widget.product);
                        } else {
                          context
                              .read<CartProvider>()
                              .addToCart(widget.product);
                        }
                        context.read<CartProvider>().changeTotalPrice();
                        context
                            .read<CartProvider>()
                            .changeTotalPriceAdditionalCart();
                        var currentText = int.parse(_controller.text);
                        widget.manageCountVisible(true);
                        setState(() {
                          _controller.text =
                              (int.parse(_controller.text) + 1).toString();
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 17),
                          decoration: BoxDecoration(
                              color: appColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            "+",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(appColor)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      langs[authProvider.langIndex]['add-product'],
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Image.asset(
                    widget.product.image,
                    fit: BoxFit.cover,
                    width: 80,
                  ),
                ),
              ),
              Text(
                widget.product.name,
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langs[authProvider.langIndex]['price'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    authProvider.isAuth == false ||
                            authProvider.user.name == 'test'
                        ? '100' + langs[authProvider.langIndex]['currency']
                        : widget.product.price.toString() +
                            langs[authProvider.langIndex]['currency'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langs[authProvider.langIndex]['category'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.product.category,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langs[authProvider.langIndex]['type'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.product.typesize,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langs[authProvider.langIndex]['producer'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    widget.product.producer,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langs[authProvider.langIndex]['have'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  widget.product.count > 100 ||
                          authProvider.isAuth == false ||
                          authProvider.user.name == 'test'
                      ? Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.greenAccent,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                langs[authProvider.langIndex]
                                    ['have-status-many'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      : widget.product.count < 1
                          ? Row(
                              children: [
                                Icon(
                                  Icons.close,
                                  color: Colors.redAccent,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    langs[authProvider.langIndex]
                                        ['have-status-none'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              widget.product.count.toString(),
                              style: const TextStyle(fontSize: 16),
                            )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
