import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tires_app/models/User/User.dart';
import 'package:tires_app/routes/router.dart';
import 'package:tires_app/widgets/notifications.dart';

import '../services/languages.dart';

class ProfileListItem extends StatelessWidget {
  late bool isAuth;
  late dynamic route;
  late String text;
  late User user;

  ProfileListItem(
    bool this.isAuth,
    dynamic this.route,
    String this.text,
    User this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            // if (!isAuth) {
            //   showToastMessage_auth(
            //       fToast, context, 'Необходимо войти в приложение');
            //   return;
            // }
            user.act_sverki_detail
                ? context.router.push(route)
                : showAlert(context, "Доступ запрещен", AlertType.error);
          },
          child: Row(
            children: [
              Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        const Divider(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
