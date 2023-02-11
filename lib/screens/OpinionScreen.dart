import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tires_app/constants/colors.dart';
import 'package:tires_app/providers/auth_provider.dart';
import 'package:tires_app/providers/cart_provider.dart';
import 'package:tires_app/widgets/notifications.dart';

class OpinionScreen extends StatefulWidget {
  OpinionScreen({Key? key}) : super(key: key);

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  // late FToast fToast;
  String theme = "";
  String content = "";
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    // fToast = FToast();
    // fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: appColor,
        title: const Text("Обратная связь"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appColor,
        onPressed: () async {
          if (theme != '' && content != '') {
            final status_message =
                await context.read<AuthProvider>().sendOpinion(theme, content);
            if (status_message) {
              showAlert(context, "Сообщение отправлено", AlertType.success);
              setState(() {
                theme = '';
                content = '';
              });
            } else {
              showAlert(
                  context, "Произошла ошибка при отправке", AlertType.error);
            }
          } else {
            showAlert(
                context, "Произошла ошибка при отправке", AlertType.error);
          }
        },
        label: const Text("Отправить"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              maxLines: 1,
              onChanged: (e) {
                setState(() {
                  theme = e;
                });
              },
              decoration: InputDecoration(
                hintText: "Тема сообщения",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColorDark),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              maxLines: 15,
              onChanged: (e) {
                setState(() {
                  content = e;
                });
              },
              decoration: InputDecoration(
                hintText: "Текст сообщения",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColorDark),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
