// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    ConnectRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ConnectScreen(),
      );
    },
    ProductRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ProductScreen(),
      );
    },
    OrdersRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const OrdersScreen(),
      );
    },
    ProfileRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    MainRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const MainScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    RegRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const RegScreen(),
      );
    },
    DetailRoute.name: (routeData) {
      final args = routeData.argsAs<DetailRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: DetailScreen(
          key: args.key,
          product: args.product,
          manageCountVisible: args.manageCountVisible,
          isaddition: args.isaddition,
        ),
      );
    },
    OrderDetailRoute.name: (routeData) {
      final args = routeData.argsAs<OrderDetailRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: OrderDetailScreen(
          key: args.key,
          order: args.order,
        ),
      );
    },
    CartRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CartScreen(),
      );
    },
    CollationActRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CollationActScreen(),
      );
    },
    CollationActDetailRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const CollationActDetailScreen(),
      );
    },
    AccountBonusRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const AccountBonusScreen(),
      );
    },
    DeficitRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const DeficitScreen(),
      );
    },
    NotificationRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const NotificationScreen(),
      );
    },
    ChangeLanguageRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ChangeLanguageScreen(),
      );
    },
    FilterRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const FilterScreen(),
      );
    },
    AdditionOrderRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const AdditionOrderScreen(),
      );
    },
    AdditionOrderListRoute.name: (routeData) {
      final args = routeData.argsAs<AdditionOrderListRouteArgs>(
          orElse: () => const AdditionOrderListRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: AdditionOrderListScreen(key: args.key),
      );
    },
    NotificationDetailRoute.name: (routeData) {
      final args = routeData.argsAs<NotificationDetailRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: NotificationDetailScreen(
          key: args.key,
          products: args.products,
        ),
      );
    },
    OpinionRoute.name: (routeData) {
      final args = routeData.argsAs<OpinionRouteArgs>(
          orElse: () => const OpinionRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: OpinionScreen(key: args.key),
      );
    },
    SettingsRoute.name: (routeData) {
      final args = routeData.argsAs<SettingsRouteArgs>(
          orElse: () => const SettingsRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: SettingsScreen(key: args.key),
      );
    },
    NotificationCategoryDetailRoute.name: (routeData) {
      final args = routeData.argsAs<NotificationCategoryDetailRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: NotificationCategoryDetailScreen(
          key: args.key,
          notifications: args.notifications,
        ),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          ConnectRoute.name,
          path: '/',
        ),
        RouteConfig(
          ProductRoute.name,
          path: '/product-screen',
        ),
        RouteConfig(
          OrdersRoute.name,
          path: '/orders-screen',
        ),
        RouteConfig(
          ProfileRoute.name,
          path: '/profile-screen',
        ),
        RouteConfig(
          MainRoute.name,
          path: '/main-screen',
        ),
        RouteConfig(
          LoginRoute.name,
          path: '/login-screen',
        ),
        RouteConfig(
          RegRoute.name,
          path: '/reg-screen',
        ),
        RouteConfig(
          DetailRoute.name,
          path: '/detail-screen',
        ),
        RouteConfig(
          OrderDetailRoute.name,
          path: '/order-detail-screen',
        ),
        RouteConfig(
          CartRoute.name,
          path: '/cart-screen',
        ),
        RouteConfig(
          CollationActRoute.name,
          path: '/collation-act-screen',
        ),
        RouteConfig(
          CollationActDetailRoute.name,
          path: '/collation-act-detail-screen',
        ),
        RouteConfig(
          AccountBonusRoute.name,
          path: '/account-bonus-screen',
        ),
        RouteConfig(
          DeficitRoute.name,
          path: '/deficit-screen',
        ),
        RouteConfig(
          NotificationRoute.name,
          path: '/notification-screen',
        ),
        RouteConfig(
          ChangeLanguageRoute.name,
          path: '/change-language-screen',
        ),
        RouteConfig(
          FilterRoute.name,
          path: '/filter-screen',
        ),
        RouteConfig(
          AdditionOrderRoute.name,
          path: '/addition-order-screen',
        ),
        RouteConfig(
          AdditionOrderListRoute.name,
          path: '/addition-order-list-screen',
        ),
        RouteConfig(
          NotificationDetailRoute.name,
          path: '/notification-detail-screen',
        ),
        RouteConfig(
          OpinionRoute.name,
          path: '/opinion-screen',
        ),
        RouteConfig(
          SettingsRoute.name,
          path: '/settings-screen',
        ),
        RouteConfig(
          NotificationCategoryDetailRoute.name,
          path: '/notification-category-detail-screen',
        ),
      ];
}

/// generated route for
/// [ConnectScreen]
class ConnectRoute extends PageRouteInfo<void> {
  const ConnectRoute()
      : super(
          ConnectRoute.name,
          path: '/',
        );

  static const String name = 'ConnectRoute';
}

/// generated route for
/// [ProductScreen]
class ProductRoute extends PageRouteInfo<void> {
  const ProductRoute()
      : super(
          ProductRoute.name,
          path: '/product-screen',
        );

  static const String name = 'ProductRoute';
}

/// generated route for
/// [OrdersScreen]
class OrdersRoute extends PageRouteInfo<void> {
  const OrdersRoute()
      : super(
          OrdersRoute.name,
          path: '/orders-screen',
        );

  static const String name = 'OrdersRoute';
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: '/profile-screen',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute()
      : super(
          MainRoute.name,
          path: '/main-screen',
        );

  static const String name = 'MainRoute';
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login-screen',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [RegScreen]
class RegRoute extends PageRouteInfo<void> {
  const RegRoute()
      : super(
          RegRoute.name,
          path: '/reg-screen',
        );

  static const String name = 'RegRoute';
}

/// generated route for
/// [DetailScreen]
class DetailRoute extends PageRouteInfo<DetailRouteArgs> {
  DetailRoute({
    Key? key,
    required Product product,
    required void Function(bool) manageCountVisible,
    required bool isaddition,
  }) : super(
          DetailRoute.name,
          path: '/detail-screen',
          args: DetailRouteArgs(
            key: key,
            product: product,
            manageCountVisible: manageCountVisible,
            isaddition: isaddition,
          ),
        );

  static const String name = 'DetailRoute';
}

class DetailRouteArgs {
  const DetailRouteArgs({
    this.key,
    required this.product,
    required this.manageCountVisible,
    required this.isaddition,
  });

  final Key? key;

  final Product product;

  final void Function(bool) manageCountVisible;

  final bool isaddition;

  @override
  String toString() {
    return 'DetailRouteArgs{key: $key, product: $product, manageCountVisible: $manageCountVisible, isaddition: $isaddition}';
  }
}

/// generated route for
/// [OrderDetailScreen]
class OrderDetailRoute extends PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    Key? key,
    required Order order,
  }) : super(
          OrderDetailRoute.name,
          path: '/order-detail-screen',
          args: OrderDetailRouteArgs(
            key: key,
            order: order,
          ),
        );

  static const String name = 'OrderDetailRoute';
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({
    this.key,
    required this.order,
  });

  final Key? key;

  final Order order;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, order: $order}';
  }
}

/// generated route for
/// [CartScreen]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute()
      : super(
          CartRoute.name,
          path: '/cart-screen',
        );

  static const String name = 'CartRoute';
}

/// generated route for
/// [CollationActScreen]
class CollationActRoute extends PageRouteInfo<void> {
  const CollationActRoute()
      : super(
          CollationActRoute.name,
          path: '/collation-act-screen',
        );

  static const String name = 'CollationActRoute';
}

/// generated route for
/// [CollationActDetailScreen]
class CollationActDetailRoute extends PageRouteInfo<void> {
  const CollationActDetailRoute()
      : super(
          CollationActDetailRoute.name,
          path: '/collation-act-detail-screen',
        );

  static const String name = 'CollationActDetailRoute';
}

/// generated route for
/// [AccountBonusScreen]
class AccountBonusRoute extends PageRouteInfo<void> {
  const AccountBonusRoute()
      : super(
          AccountBonusRoute.name,
          path: '/account-bonus-screen',
        );

  static const String name = 'AccountBonusRoute';
}

/// generated route for
/// [DeficitScreen]
class DeficitRoute extends PageRouteInfo<void> {
  const DeficitRoute()
      : super(
          DeficitRoute.name,
          path: '/deficit-screen',
        );

  static const String name = 'DeficitRoute';
}

/// generated route for
/// [NotificationScreen]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute()
      : super(
          NotificationRoute.name,
          path: '/notification-screen',
        );

  static const String name = 'NotificationRoute';
}

/// generated route for
/// [ChangeLanguageScreen]
class ChangeLanguageRoute extends PageRouteInfo<void> {
  const ChangeLanguageRoute()
      : super(
          ChangeLanguageRoute.name,
          path: '/change-language-screen',
        );

  static const String name = 'ChangeLanguageRoute';
}

/// generated route for
/// [FilterScreen]
class FilterRoute extends PageRouteInfo<void> {
  const FilterRoute()
      : super(
          FilterRoute.name,
          path: '/filter-screen',
        );

  static const String name = 'FilterRoute';
}

/// generated route for
/// [AdditionOrderScreen]
class AdditionOrderRoute extends PageRouteInfo<void> {
  const AdditionOrderRoute()
      : super(
          AdditionOrderRoute.name,
          path: '/addition-order-screen',
        );

  static const String name = 'AdditionOrderRoute';
}

/// generated route for
/// [AdditionOrderListScreen]
class AdditionOrderListRoute extends PageRouteInfo<AdditionOrderListRouteArgs> {
  AdditionOrderListRoute({Key? key})
      : super(
          AdditionOrderListRoute.name,
          path: '/addition-order-list-screen',
          args: AdditionOrderListRouteArgs(key: key),
        );

  static const String name = 'AdditionOrderListRoute';
}

class AdditionOrderListRouteArgs {
  const AdditionOrderListRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'AdditionOrderListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [NotificationDetailScreen]
class NotificationDetailRoute
    extends PageRouteInfo<NotificationDetailRouteArgs> {
  NotificationDetailRoute({
    Key? key,
    required List<dynamic> products,
  }) : super(
          NotificationDetailRoute.name,
          path: '/notification-detail-screen',
          args: NotificationDetailRouteArgs(
            key: key,
            products: products,
          ),
        );

  static const String name = 'NotificationDetailRoute';
}

class NotificationDetailRouteArgs {
  const NotificationDetailRouteArgs({
    this.key,
    required this.products,
  });

  final Key? key;

  final List<dynamic> products;

  @override
  String toString() {
    return 'NotificationDetailRouteArgs{key: $key, products: $products}';
  }
}

/// generated route for
/// [OpinionScreen]
class OpinionRoute extends PageRouteInfo<OpinionRouteArgs> {
  OpinionRoute({Key? key})
      : super(
          OpinionRoute.name,
          path: '/opinion-screen',
          args: OpinionRouteArgs(key: key),
        );

  static const String name = 'OpinionRoute';
}

class OpinionRouteArgs {
  const OpinionRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'OpinionRouteArgs{key: $key}';
  }
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({Key? key})
      : super(
          SettingsRoute.name,
          path: '/settings-screen',
          args: SettingsRouteArgs(key: key),
        );

  static const String name = 'SettingsRoute';
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'SettingsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [NotificationCategoryDetailScreen]
class NotificationCategoryDetailRoute
    extends PageRouteInfo<NotificationCategoryDetailRouteArgs> {
  NotificationCategoryDetailRoute({
    Key? key,
    required List<dynamic> notifications,
  }) : super(
          NotificationCategoryDetailRoute.name,
          path: '/notification-category-detail-screen',
          args: NotificationCategoryDetailRouteArgs(
            key: key,
            notifications: notifications,
          ),
        );

  static const String name = 'NotificationCategoryDetailRoute';
}

class NotificationCategoryDetailRouteArgs {
  const NotificationCategoryDetailRouteArgs({
    this.key,
    required this.notifications,
  });

  final Key? key;

  final List<dynamic> notifications;

  @override
  String toString() {
    return 'NotificationCategoryDetailRouteArgs{key: $key, notifications: $notifications}';
  }
}
