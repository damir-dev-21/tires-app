import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tires_app/models/Product/Product.dart';
import 'package:tires_app/screens/AdditionOrderListScreen.dart';
import 'package:tires_app/screens/AdditionOrderScreen.dart';
import 'package:tires_app/screens/OpinionScreen.dart';
import 'package:tires_app/screens/SettingScreen.dart';
import 'package:tires_app/screens/accounts/AccountBonusScreen.dart';
import 'package:tires_app/screens/ChangeLanguageScreen.dart';
import 'package:tires_app/screens/accounts/CollationAct.dart';
import 'package:tires_app/screens/accounts/CollationActDetail.dart';
import 'package:tires_app/screens/ConnectScreen.dart';
import 'package:tires_app/screens/accounts/DeficitScreen.dart';
import 'package:tires_app/screens/FilterScreen.dart';
import 'package:tires_app/screens/MainScreen.dart';
import 'package:tires_app/screens/NotificationScreen.dart';
import 'package:tires_app/screens/auth/LoginScreen.dart';
import 'package:tires_app/screens/auth/RegScreen.dart';
import 'package:tires_app/screens/detail/DetailScreen.dart';
import 'package:tires_app/screens/detail/NotificationCategoryDetailScreen.dart';
import 'package:tires_app/screens/detail/NotificationDetailScreen.dart';
import 'package:tires_app/screens/detail/OrderDetailScreen.dart';
import 'package:tires_app/screens/main/CartScreen.dart';
import 'package:tires_app/screens/main/OrdersScreen.dart';
import 'package:tires_app/screens/main/ProductsScreen.dart';
import 'package:tires_app/screens/main/ProfileScreen.dart';

import '../models/Order.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: ConnectScreen, initial: true),
    AutoRoute(page: ProductScreen),
    AutoRoute(page: OrdersScreen),
    AutoRoute(page: ProfileScreen),
    AutoRoute(page: MainScreen),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: RegScreen),
    AutoRoute(page: DetailScreen),
    AutoRoute(page: OrderDetailScreen),
    AutoRoute(page: CartScreen),
    AutoRoute(page: CollationActScreen),
    AutoRoute(page: CollationActDetailScreen),
    AutoRoute(page: AccountBonusScreen),
    AutoRoute(page: DeficitScreen),
    AutoRoute(page: NotificationScreen),
    AutoRoute(page: ChangeLanguageScreen),
    AutoRoute(page: FilterScreen),
    AutoRoute(page: AdditionOrderScreen),
    AutoRoute(page: AdditionOrderListScreen),
    AutoRoute(page: NotificationDetailScreen),
    AutoRoute(page: OpinionScreen),
    AutoRoute(page: SettingsScreen),
    AutoRoute(page: NotificationCategoryDetailScreen),
  ],
)
class AppRouter extends _$AppRouter {}
