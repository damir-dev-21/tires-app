import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/models/Order.dart';
import 'package:tires_app/models/Orders/Orders.dart';
import 'package:tires_app/models/Product/Product.dart';
import 'package:tires_app/models/Products/Products.dart';
import 'package:tires_app/models/User/User.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/balance_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/providers/products_provider.dart';
import 'package:tires_app/screens/SplashScreen.dart';
import 'package:tires_app/services/firebase_notification_handler.dart';
import 'package:tires_app/services/notification_service.dart';

import 'models/Cart/Cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backroundHandler);

  await dotenv.load(fileName: "lib/.env");
  await Permission.phone.request();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductsAdapter());
  Hive.registerAdapter(OrdersAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Product>('products');
  await Hive.openBox<Orders>('orders');
  await Hive.openBox<Cart>('cart');

  final ProductProvider productProvider = ProductProvider();
  final AuthProvider authProvider = AuthProvider();
  final CartProvider cartProvider = CartProvider();

  authProvider.getStatus();
  productProvider.getSynchronization(null);
  cartProvider.checkOrders();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => authProvider),
    ChangeNotifierProvider(create: (_) => productProvider),
    ChangeNotifierProvider(create: (_) => cartProvider),
    ChangeNotifierProvider(create: (_) => BalanceProvider()),
  ], child: SplashScreen()));
}

Future<void> _backroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handle background service $message");
  dynamic data = message.data['data'];
  FirebaseNotifications.showNotification(data['title'], data['body']);
}
