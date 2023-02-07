import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tires_app/constants/config.dart';
import 'package:tires_app/models/balance.dart';
import 'package:http/http.dart' as http;

class BalanceProvider extends ChangeNotifier {
  final List<Balance> balance = [];
  final List<Map<String, dynamic>> balanceDetail = [];
  final List<Map<String, dynamic>> accountBonus = [];
  final List<Map<String, dynamic>> deficitList = [];
  late File? balanceDetailFile;
  late File? balanceFile;
  late File? accountBonusFile;
  Map<String, dynamic> initial_balance = {"debet": "", "credit": ""};
  Map<String, dynamic> final_balance = {"debet": "", "credit": ""};
  double debet_total = 0;
  double credit_total = 0;
  bool isLoad = false;
  bool isFolderCreated = false;
  Directory? directory;

  Future<void> checkDocumentFolder() async {
    try {
      if (!isFolderCreated) {
        directory = await getApplicationDocumentsDirectory();
        await directory!.exists().then((value) {
          if (value) directory!.create();
          isFolderCreated = true;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getBalance(String begin, String end, String client) async {
    Map<String, dynamic> params = {
      "client": client,
      "begin_period": begin,
      "end_period": end,
    };
    Map<String, dynamic> params_base64 = {
      "clients": [client],
      "start_period": begin,
      "end_period": end,
    };

    try {
      isLoad = true;
      notifyListeners();
      final responce = await http.post(Uri.parse(urlBalance),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode(params));
      final responce_base64 = await http.post(Uri.parse(urlBalance_base64),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode(params_base64));

      balance.clear();
      initial_balance = {"debet": "", "credit": ""};
      final_balance = {"debet": "", "credit": ""};

      if (responce.statusCode == 200 && responce_base64.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        debet_total = double.parse(extractedData['debit_total'].toString());
        credit_total = double.parse(extractedData['credit_total'].toString());
        initial_balance = {
          "debet": extractedData['initial_balance']['debet_remind'],
          "credit": extractedData['initial_balance']['kredit_remind']
        };
        final_balance = {
          "debet": extractedData['final_balance']['debet_remind'],
          "credit": extractedData['final_balance']['kredit_remind']
        };
        extractedData['results'].forEach((element) {
          Balance balanceRes = Balance(
              element['id'],
              element['registrator'],
              element["date"],
              double.parse(element['debet'].toString()),
              double.parse(element['kredet'].toString()));
          balance.add(balanceRes);
        });

        String body_base64 = utf8.decode(responce_base64.bodyBytes);
        final extracted_data_base64 =
            json.decode(body_base64) as Map<String, dynamic>;
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String base64_string =
            extracted_data_base64['results'][0]['file_base64'];
        print(base64_string);
        Uint8List bytes = base64.decode(base64_string);
        await checkDocumentFolder();
        String dir = directory!.path + '/' + "act_compare" + ".pdf";
        File file = File(dir);
        if (!file.existsSync()) file.create();
        await file.writeAsBytes(bytes);
        balanceFile = file;

        isLoad = false;
        print(initial_balance);
        notifyListeners();
      } else {
        isLoad = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> getBalanceDetail(String begin, String end, String client) async {
    String url_params = "id=${client}&start_period=${begin}&end_period=${end}";

    try {
      isLoad = true;
      notifyListeners();
      final responce = await http.get(Uri.parse(urlBalanceDetail + url_params),
          headers: {'Authorization': basicAuth_siyobAgromash});
      final responce_base64 = await http.get(
          Uri.parse(urlBalanceDetail_base64 + url_params),
          headers: {'Authorization': basicAuth_siyobAgromash});
      isLoad = true;
      notifyListeners();
      if (responce.statusCode == 200 && responce_base64.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extracted_data = json.decode(body) as Map<String, dynamic>;

        extracted_data['results']['results'].forEach((element) {
          balanceDetail.add(element);
        });

        String body_base64 = utf8.decode(responce_base64.bodyBytes);
        final extracted_data_base64 =
            json.decode(body_base64) as Map<String, dynamic>;
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String base64_string =
            extracted_data_base64['results'][0]['file_base64'];
        Uint8List bytes = base64.decode(base64_string);
        await checkDocumentFolder();
        String dir = directory!.path + '/' + "act_compare" + ".pdf";
        File file = File(dir);
        if (!file.existsSync()) file.create();
        await file.writeAsBytes(bytes);
        balanceDetailFile = file;

        isLoad = false;
        notifyListeners();
      } else {
        isLoad = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      isLoad = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> getAccountBonus(String begin, String end, String client) async {
    Map<String, dynamic> params = {
      "client": client,
      "begin_period": begin,
      "end_period": end,
    };
    Map<String, dynamic> params_base64 = {
      "client": client,
      "start_period": begin,
      "end_period": end,
    };

    try {
      isLoad = true;
      notifyListeners();
      final responce = await http.post(Uri.parse(urlBonusReport),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode(params));
      final responce_base64 = await http.post(Uri.parse(urlBonusReport_base64),
          headers: {'Authorization': basicAuth_sklad!},
          body: jsonEncode(params_base64));
      isLoad = true;

      notifyListeners();

      if (responce.statusCode == 200 && responce_base64.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;

        extractedData['results'].forEach((element) {
          accountBonus.add(element);
        });

        String body_base64 = utf8.decode(responce_base64.bodyBytes);
        final extracted_data_base64 =
            json.decode(body_base64) as Map<String, dynamic>;
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String base64_string =
            extracted_data_base64['results'][0]['file_base64'];
        print(base64_string);
        Uint8List bytes = base64.decode(base64_string);
        await checkDocumentFolder();
        String dir = directory!.path + '/' + "act_compare" + ".pdf";
        File file = File(dir);
        if (!file.existsSync()) file.create();
        await file.writeAsBytes(bytes);
        accountBonusFile = file;

        isLoad = false;
        notifyListeners();
      } else {
        isLoad = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> getDeficitList() async {
    try {
      isLoad = true;
      notifyListeners();
      final responce = await http.get(
        Uri.parse(urlDeficitList),
        headers: {'Authorization': basicAuth_sklad!},
      );

      isLoad = true;

      notifyListeners();

      if (responce.statusCode == 200) {
        String body = utf8.decode(responce.bodyBytes);
        final extractedData = json.decode(body) as Map<String, dynamic>;
        deficitList.clear();
        notifyListeners();
        extractedData['results'].forEach((element) {
          deficitList.add({
            "Товар": element['Товар'].replaceAll(RegExp("\\s+"), " "),
            "НС": element['НС']
          });
          print(element);
        });

        isLoad = false;
        notifyListeners();
      } else {
        isLoad = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
