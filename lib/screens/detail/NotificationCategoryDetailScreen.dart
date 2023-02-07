import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tires_app/models/Message.dart';
import 'package:tires_app/models/Product.dart';
import 'package:tires_app/providers/balance_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tires_app/widgets/search_item_widget.dart';

import '../../models/Order.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';

class NotificationCategoryDetailScreen extends StatefulWidget {
  NotificationCategoryDetailScreen({Key? key, required this.notifications})
      : super(key: key);
  final List<dynamic> notifications;
  @override
  State<NotificationCategoryDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends State<NotificationCategoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    final BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context);

    void openFile(file) async {
      if (file == null) return;

      // await OpenFile.open(file.path);
    }

    bool isFolderCreated = false;
    Directory? directory;

    Future<void> checkDocumentFolder() async {
      try {
        if (!isFolderCreated) {
          directory = await getApplicationDocumentsDirectory();
          await directory!.exists().then((value) {
            if (value) directory!.create();
            isFolderCreated = true;
          });
          setState(() {});
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: widget.notifications.length,
                itemBuilder: (ctx, index) => GestureDetector(
                  onTap: () async {
                    if (widget.notifications[index].status == 'Поступление' ||
                        widget.notifications[index].status ==
                            'Поступление_Подразделение') {
                      context.router.push(NotificationDetailRoute(
                          products: widget.notifications[index].content));
                    } else if (widget.notifications[index].status ==
                        'Прайс лист') {
                      Message message_from_list = widget.notifications[index];
                      String base64_string = message_from_list.content;
                      print(base64_string);
                      Uint8List bytes = base64.decode(base64_string);
                      await balanceProvider.checkDocumentFolder();
                      String dir = balanceProvider.directory!.path +
                          '/' +
                          message_from_list.text +
                          ".pdf";
                      File file = File(dir);
                      if (!file.existsSync()) file.create();
                      await file.writeAsBytes(bytes);
                      var balanceFile = file;

                      openFile(balanceFile);
                    } else if (widget.notifications[index].status ==
                        'Поступление_Касса') {
                      Message message_from_list = widget.notifications[index];
                      var content = json.decode(message_from_list.content)
                          as Map<String, dynamic>;
                      authProvider.showAlert(context,
                          "Сумма: ${content['money']}", AlertType.info);
                    } else {
                      final Order order_finded = cartProvider.orders.firstWhere(
                          (element) =>
                              element.userId ==
                              widget.notifications[index].content);
                      context.router
                          .push(OrderDetailRoute(order: order_finded));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.message,
                          size: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            widget.notifications[index].text,
                          ),
                        ),
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: widget.notifications[index].status ==
                                  'Поступление'
                              ? Colors.yellow
                              : widget.notifications[index].status ==
                                      'Поступление_Подразделение'
                                  ? Colors.yellowAccent
                                  : widget.notifications[index].status ==
                                          'Прайс лист'
                                      ? Colors.green
                                      : Colors.red,
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      )),
    );
  }
}
