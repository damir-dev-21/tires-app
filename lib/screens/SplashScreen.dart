import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:tires_app/routes/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _appRouter = AppRouter();

  late Image image;

  @override
  void initState() {
    image = Image.asset(
      "assets/SiyobAgromash.png",
      height: 200,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image.image, context);
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AnimatedSplashScreen(
            splash: SizedBox(
                width: double.infinity, height: double.infinity, child: image),
            backgroundColor: Colors.white,
            duration: 3000,
            nextScreen: MaterialApp.router(
              scaffoldMessengerKey: scaffoldMessengerKey,
              debugShowCheckedModeBanner: false,
              routerDelegate: _appRouter.delegate(),
              routeInformationParser: _appRouter.defaultRouteParser(),
            )));
  }
}
