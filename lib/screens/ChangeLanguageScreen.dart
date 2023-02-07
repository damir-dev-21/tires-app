import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/services/languages.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({Key? key}) : super(key: key);

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  bool? checkboxRus = false;
  bool? checkboxEng = false;
  bool? checkboxUzb = false;

  @override
  void initState() {
    super.initState();
    int idx = context.read<AuthProvider>().langIndex;

    if (idx == 0) {
      checkboxRus = true;
    } else if (idx == 1) {
      checkboxEng = true;
    } else if (idx == 2) {
      checkboxUzb = true;
    } else {
      checkboxRus = false;
      checkboxEng = false;
      checkboxUzb = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(langs[authProvider.langIndex]['changeLangText']),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Checkbox(
                      value: checkboxRus,
                      onChanged: (e) async {
                        setState(() {
                          checkboxEng = false;
                          checkboxUzb = false;
                          checkboxRus = e;
                        });
                        await authProvider.changeLang(0);
                        final user = context.read<AuthProvider>().user;
                        user.language = 0;
                        final box = authProvider.getLangs();
                        // box.add(Languages()
                        //   ..id = 0
                        //   ..value = 0);
                        box.put('1', user);
                      }),
                  const Text('Русский')
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Checkbox(
                      value: checkboxEng,
                      onChanged: (e) async {
                        setState(() {
                          checkboxRus = false;
                          checkboxUzb = false;
                          checkboxEng = e;
                        });
                        await authProvider.changeLang(1);

                        final user = context.read<AuthProvider>().user;
                        user.language = 1;
                        final box = authProvider.getLangs();
                        // box.add(Languages()
                        //   ..id = 0
                        //   ..value = 1);
                        box.put('1', user);
                      }),
                  const Text('English')
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Checkbox(
                      value: checkboxUzb,
                      onChanged: (e) async {
                        setState(() {
                          checkboxRus = false;
                          checkboxEng = false;
                          checkboxUzb = e;
                        });
                        await authProvider.changeLang(2);
                        final user = context.read<AuthProvider>().user;
                        user.language = 2;
                        final box = authProvider.getLangs();
                        // box.add(Languages()
                        //   ..id = 0
                        //   ..value = 2);
                        box.put('1', user);
                      }),
                  const Text('O`zbek')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
