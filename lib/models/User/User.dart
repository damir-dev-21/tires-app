import 'package:hive/hive.dart';

part 'User.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late int id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String password;
  @HiveField(3)
  late String token;
  @HiveField(4)
  late int language;
  @HiveField(5)
  late List<dynamic> customers;
  @HiveField(6)
  late String imei;
  @HiveField(7)
  late String messaging_token;
  @HiveField(8)
  late bool act_sverki;
  @HiveField(9)
  late bool act_sverki_detail;
  @HiveField(10)
  late bool addition;
  @HiveField(11)
  late bool balance;
  @HiveField(12)
  late bool deficit;
  @HiveField(13)
  late bool load;
  @HiveField(14)
  late bool group_customers;
  @HiveField(15)
  late bool bonus;
  @HiveField(16)
  late bool subdivision_access;
  @HiveField(17)
  late List<dynamic> subdivisions;
  @HiveField(18)
  late bool trust_payment;
}
