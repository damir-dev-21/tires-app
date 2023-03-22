import 'package:flutter_driver/flutter_driver.dart';

import 'package:test/test.dart';

void main() {
  group('Add to cart 10 items', () {
    final usernameField = find.byValueKey('email');
    final passwordField = find.byValueKey('password');
    final signInBtn = find.byValueKey('signIn');

    final addBtnText = find.text('Добавить');
    final addBtnCount = find.byValueKey('add');
    final removeBtnCount = find.byValueKey('remove');

    late FlutterDriver driver;

    Future<bool> isPresent(SerializableFinder byValueKey,
        {Duration timeout = const Duration(seconds: 1)}) async {
      try {
        await driver.waitFor(byValueKey, timeout: timeout);
        return true;
      } catch (exception) {
        return false;
      }
    }

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('login', () async {
      if (await isPresent(signInBtn)) {
        await driver.tap(signInBtn);
      }

      await driver.tap(usernameField);
      await driver.enterText('test');

      await driver.tap(passwordField);
      await driver.enterText('123');

      await driver.tap(signInBtn);
      await driver.waitFor(find.text("Авторизация прошла успешно"));
    });

    test('set 10 item to cart', () async {
      if (await isPresent(signInBtn)) {
        await driver.tap(addBtnText);
        for (var i = 0; i < 10; i++) {
          await driver.tap(addBtnCount);
        }
      }
    });
  });
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // testWidgets('Authentification', (WidgetTester tester) async {
  //   app.main();
  //   await tester.pumpAndSettle();
  // });

  // testWidgets("Add to cart 10 items", (WidgetTester tester) async {
  //   app.main();
  //   await tester.pumpAndSettle();
  //   final Finder add_text_button = find.text('Добавить');
  //   tester.tap(add_text_button);
  //   final Finder add_button = find.byIcon(Icons.add);

  //   for (var i = 0; i < 10; i++) {
  //     await tester.tap(add_button);
  //     await Future.delayed(const Duration(seconds: 1));
  //   }

  //   await tester.pumpAndSettle();

  //   expect(find.text('10'), findsOneWidget);
  // });
}
