import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/models/Product.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/widgets/search_item_widget.dart';

class AdditionOrderListScreen extends StatefulWidget {
  AdditionOrderListScreen({Key? key}) : super(key: key);

  @override
  State<AdditionOrderListScreen> createState() =>
      _AdditionOrderListScreenState();
}

class _AdditionOrderListScreenState extends State<AdditionOrderListScreen> {
  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                cartProvider.clearAdditionCart();
                setState(() {});
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: SafeArea(
          child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: cartProvider.additional_cart.length,
                    itemBuilder: (ctx, i) {
                      final Product product = cartProvider.additional_cart[i];
                      return SearchItemWidget(
                          product: product, type: 'additional');
                    }))
          ],
        ),
      )),
    );
  }
}
