import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/models/Message.dart';
import 'package:tires_app/models/Order.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/balance_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/screens/detail/NotificationCategoryDetailScreen.dart';
import 'package:tires_app/services/database_helper.dart';
import 'package:tires_app/services/notification_service.dart';
import 'package:web_socket_channel/status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    final BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context);

    productProvider.checkNotifications();
    void openFile(file) async {
      if (file == null) return;

      await OpenFile.open(file.path);
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: appColor,
          title: Text("Уведомления"),
          actions: [
            isLoad
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : IconButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoad = true;
                        });
                        await productProvider.getNotifications();
                      } catch (e) {
                        print(e);
                        throw e;
                      } finally {
                        setState(() {
                          isLoad = false;
                        });
                      }
                    },
                    icon: Icon(Icons.sync_rounded))
          ],
        ),
        body: ListView.builder(
            itemCount: 5,
            itemBuilder: (ctx, i) {
              return GestureDetector(
                onTap: () {
                  final list = [];

                  productProvider.list_of_messages.forEach((e) {
                    if (i == 0 &&
                        (e.status == 'Поступление' ||
                            e.status == 'Поступление_Подразделение')) {
                      list.add(e);
                    } else if (i == 3 && e.status == 'Прайс лист') {
                      list.add(e);
                    } else if (i == 2 && e.status == 'Поступление_Касса') {
                      list.add(e);
                    } else if (i == 1 && e.status == 'Заказ') {
                      list.add(e);
                    } else if (i == 4 && e.status == 'Акт сверки') {
                      list.add(e);
                    }
                  });

                  list.sort((a, b) {
                    return DateTime.parse(b.date)
                        .compareTo(DateTime.parse(a.date));
                  });
                  context.router.push(
                      NotificationCategoryDetailRoute(notifications: list));
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 50,
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: i == 0
                              ? Colors.yellow
                              : i == 1
                                  ? Colors.red
                                  : i == 2
                                      ? Colors.yellowAccent
                                      : i == 3
                                          ? Colors.green
                                          : Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(i == 0
                            ? "Поступления"
                            : i == 1
                                ? "Изменение заказов"
                                : i == 2
                                    ? "Поступление денег"
                                    : i == 3
                                        ? "Прайс листы"
                                        : 'Прочее'),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width / 4,
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
    // ListView.builder(
    //   itemCount: productProvider.list_of_messages.length,
    //   itemBuilder: (ctx, index) => GestureDetector(
    //     onTap: () async {
    //       if (productProvider.list_of_messages[index].status ==
    //               'Поступление' ||
    //           productProvider.list_of_messages[index].status ==
    //               'Поступление_Подразделение') {
    //         context.router.push(NotificationDetailRoute(
    //             products: productProvider.list_of_messages[index].content));
    //       } else if (productProvider.list_of_messages[index].status ==
    //           'Прайс лист') {
    //         Message message_from_list =
    //             productProvider.list_of_messages[index];
    //         String base64_string = message_from_list.content;
    //         print(base64_string);
    //         Uint8List bytes = base64.decode(base64_string);
    //         await balanceProvider.checkDocumentFolder();
    //         String dir = balanceProvider.directory!.path +
    //             '/' +
    //             message_from_list.text +
    //             ".pdf";
    //         File file = File(dir);
    //         if (!file.existsSync()) file.create();
    //         await file.writeAsBytes(bytes);
    //         var balanceFile = file;

    //         openFile(balanceFile);
    //       } else if (productProvider.list_of_messages[index].status ==
    //           'Поступление_Касса') {
    //         Message message_from_list =
    //             productProvider.list_of_messages[index];
    //         var content = json.decode(message_from_list.content)
    //             as Map<String, dynamic>;
    //         authProvider.showAlert(
    //             context, "Сумма: ${content['money']}", AlertType.info);
    //       } else {
    //         print(productProvider.list_of_messages[index].toMap());
    //         final Order order_finded = cartProvider.orders.firstWhere(
    //             (element) =>
    //                 element.userId ==
    //                 productProvider.list_of_messages[index].content);
    //         context.router.push(OrderDetailRoute(order: order_finded));
    //       }
    //     },
    //     child: Container(
    //       decoration: BoxDecoration(
    //           color: Colors.white, borderRadius: BorderRadius.circular(10)),
    //       padding: const EdgeInsets.all(20),
    //       margin: const EdgeInsets.all(10),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Icon(
    //             Icons.message,
    //             size: 20,
    //           ),
    //           SizedBox(
    //             width: MediaQuery.of(context).size.width / 2,
    //             child: Text(
    //               productProvider.list_of_messages[index].text,
    //             ),
    //           ),
    //           CircleAvatar(
    //             radius: 5,
    //             backgroundColor: productProvider
    //                         .list_of_messages[index].status ==
    //                     'Поступление'
    //                 ? Colors.yellow
    //                 : productProvider.list_of_messages[index].status ==
    //                         'Поступление_Подразделение'
    //                     ? Colors.yellowAccent
    //                     : productProvider.list_of_messages[index].status ==
    //                             'Прайс лист'
    //                         ? Colors.green
    //                         : Colors.red,
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // ));
  }
}
