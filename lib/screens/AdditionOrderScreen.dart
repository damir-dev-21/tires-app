import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/models/Product.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/services/languages.dart';
import 'package:tires_app/widgets/search_item_widget.dart';

import '../constants/colors.dart';

class AdditionOrderScreen extends StatefulWidget {
  const AdditionOrderScreen({Key? key}) : super(key: key);

  @override
  State<AdditionOrderScreen> createState() => _AdditionOrderScreenState();
}

class _AdditionOrderScreenState extends State<AdditionOrderScreen> {
  List<Product> searchList = [];
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Дополнительный заказ"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width / 1.1,
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
                  // final prod =
                  //     productProvider.products.where((element) {
                  //   final title = element.name.toLowerCase();

                  //   return title.contains(e.toLowerCase());
                  // }).toList();
                  var text_list = e.toLowerCase().split(' ');
                  var prod = productProvider.products;

                  for (var element in text_list) {
                    prod = prod
                        .where((e) => e.name.toLowerCase().contains(element))
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
                      borderSide: const BorderSide(color: textColorDark),
                      borderRadius: BorderRadius.circular(20)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  labelText: langs[authProvider.langIndex]['search-text'],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            isSearch
                ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                                    itemCount: searchList.length,
                                    itemBuilder: (ctx, i) {
                                      final Product product = searchList[i];
                                      return product.count > 0
                                          ? SearchItemWidget(
                                              product: product,
                                              type: 'additional')
                                          : const SizedBox();
                                    })),
                          ],
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 1.4,
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                                    itemCount: productProvider.products.length,
                                    itemBuilder: (ctx, i) {
                                      final Product product =
                                          productProvider.products[i];
                                      return product.count > 0
                                          ? SearchItemWidget(
                                              product: product,
                                              type: 'additional')
                                          : const SizedBox();
                                    })),
                          ],
                        ),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
