// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

const url = "http://web.corp.siyob.uz:9696"; //global
//const url = "http://213.230.127.235:9696"; //static
// const urlProducts = "$url/supply_tires/hs/site/goods/";
//const urlOrder = "$url/supply_tires/hs/site/order/";
// const urlLogin = "$url/supply_tires/hs/site/login/";
// const urlReg = "$url/supply_tires/hs/site/reg/";
const urlProducts = "$url/sklad/hs/mobile/goods/";
const urlNotifications = "$url/sklad/hs/mobile/notifications/";
const urlLogin = "$url/sklad/hs/mobile/login/";
const urlReg = "$url/sklad/hs/mobile/reg/";
const urlOrderCheck = "$url/sklad/hs/mobile/orderCheck/";
const urlOrderConfirm = "$url/sklad/hs/mobile/confirmation_sale/";
const urlOrderReject = "$url/sklad/hs/mobile/reject_order/";
const urlSendOpinion = "http://ifelse.corp.siyob.uz:9003/api/group_mailing/";
const urlOrderConfirm_list = "$url/sklad/hs/mobile/send_confirm_list/";

const urlOrderBalance = "$url/sklad/hs/mobile/balance/";
const urlRate = "$url/sklad/hs/mobile/get_rate/";

const urlOrder = "$url/sklad/hs/mobile/order/";
const urlBalance = "$url/sklad/hs/mobile/sverka/";
const urlBalance_base64 = "$url/sklad/hs/act_sverki/";
const urlBalanceDetail = "$url/SiyobAgromash/hs/act_sverki_mobile/get?";
const urlBalanceDetail_base64 = "$url/SiyobAgromash/hs/act_sverki/get?";
const urlBonusReport = "$url/sklad/hs/mobile/bonus/";
const urlBonusReport_base64 = "$url/sklad/hs/report_bonus/";
const urlDeficitList = "$url/sklad/hs/mobile/deficit/";

String? username_sklad = dotenv.env['USERNAME_SKLAD_AUTH'];
String? password_sklad = dotenv.env['PASSWORD_SKLAD_AUTH'];
String? basicAuth_sklad =
    'Basic ' + base64.encode(utf8.encode('$username_sklad:$password_sklad'));

const String username_siyobAgromash = 'Администратор';
const String password_siyobAgromash = 'admin_sh';
String basicAuth_siyobAgromash = 'Basic ' +
    base64
        .encode(utf8.encode('$username_siyobAgromash:$password_siyobAgromash'));
