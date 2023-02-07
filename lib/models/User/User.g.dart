// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      ..id = fields[0] as int
      ..name = fields[1] as String
      ..password = fields[2] as String
      ..token = fields[3] as String
      ..language = fields[4] as int
      ..customers = (fields[5] as List).cast<dynamic>()
      ..imei = fields[6] as String
      ..messaging_token = fields[7] as String
      ..act_sverki = fields[8] as bool
      ..act_sverki_detail = fields[9] as bool
      ..addition = fields[10] as bool
      ..balance = fields[11] as bool
      ..deficit = fields[12] as bool
      ..load = fields[13] as bool
      ..group_customers = fields[14] as bool
      ..bonus = fields[15] as bool
      ..subdivision_access = fields[16] as bool
      ..subdivisions = (fields[17] as List).cast<dynamic>()
      ..trust_payment = fields[18] as bool;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.token)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.customers)
      ..writeByte(6)
      ..write(obj.imei)
      ..writeByte(7)
      ..write(obj.messaging_token)
      ..writeByte(8)
      ..write(obj.act_sverki)
      ..writeByte(9)
      ..write(obj.act_sverki_detail)
      ..writeByte(10)
      ..write(obj.addition)
      ..writeByte(11)
      ..write(obj.balance)
      ..writeByte(12)
      ..write(obj.deficit)
      ..writeByte(13)
      ..write(obj.load)
      ..writeByte(14)
      ..write(obj.group_customers)
      ..writeByte(15)
      ..write(obj.bonus)
      ..writeByte(16)
      ..write(obj.subdivision_access)
      ..writeByte(17)
      ..write(obj.subdivisions)
      ..writeByte(18)
      ..write(obj.trust_payment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
