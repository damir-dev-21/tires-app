import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/screens/main/CartScreen.dart';
import 'package:tires_app/screens/main/OrdersScreen.dart';
import 'package:tires_app/screens/main/ProductsScreen.dart';
import 'package:tires_app/screens/main/ProfileScreen.dart';
import 'package:tires_app/services/languages.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return PersistentTabView(
      context,
      controller: _controller,
      navBarHeight: 60,
      screens: const [
        ProductScreen(),
        OrdersScreen(),
        CartScreen(),
        ProfileScreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          contentPadding: 0,
          iconSize: 25,
          textStyle: const TextStyle(fontSize: 15),
          icon: const Icon(
            Icons.home,
          ),
          title: (langs[authProvider.langIndex]['main_bar']),
          inactiveColorPrimary: textColorBar,
          activeColorPrimary: appColor,
        ),
        PersistentBottomNavBarItem(
            contentPadding: 0,
            iconSize: 25,
            textStyle: const TextStyle(fontSize: 15),
            icon: const Icon(
              Icons.feed,
            ),
            title: (langs[context.read<AuthProvider>().langIndex]
                ['orders_bar']),
            inactiveColorPrimary: textColorBar,
            activeColorSecondary: appColor),
        PersistentBottomNavBarItem(
            contentPadding: 0,
            iconSize: 25,
            textStyle: const TextStyle(fontSize: 15),
            icon: const Icon(
              Icons.shopping_bag,
            ),
            title: (langs[context.read<AuthProvider>().langIndex]['cart_bar']),
            inactiveColorPrimary: textColorBar,
            activeColorSecondary: appColor),
        PersistentBottomNavBarItem(
            textStyle: const TextStyle(fontSize: 15),
            contentPadding: 0,
            iconSize: 25,
            icon: const Icon(
              Icons.account_circle,
            ),
            title: (langs[context.read<AuthProvider>().langIndex]
                ['profile_bar']),
            inactiveColorPrimary: textColorBar,
            activeColorSecondary: appColor),
      ],
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      //resizeToAvoidBottomInset: true,
      stateManagement: _controller.index == 0 ? false : true,
      navBarStyle: NavBarStyle.style8,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: const NavBarDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        colorBehindNavBar: Colors.black,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.once,

      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
    );
  }
}
