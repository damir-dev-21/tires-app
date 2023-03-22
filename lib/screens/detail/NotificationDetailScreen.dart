import 'package:flutter/material.dart';
import 'package:tires_app/models/Product/Product.dart';
import 'package:tires_app/widgets/search_item_widget.dart';

class NotificationDetailScreen extends StatefulWidget {
  NotificationDetailScreen({Key? key, required this.products})
      : super(key: key);
  final List<dynamic> products;
  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
                itemCount: widget.products.length,
                itemBuilder: (ctx, i) {
                  final Product product = Product.fromJson(widget.products[i]);
                  return SearchItemWidget(product: product, type: 'cart');
                }),
          ),
        ],
      )),
    );
  }
}
