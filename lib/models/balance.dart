class Balance {
  final int id;
  final String registrator;
  final String registratorDate;
  final double debet;
  final double kredit;

  Balance(
      this.id, this.registrator, this.registratorDate, this.debet, this.kredit);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'registrator': registrator,
      'registratorDate': registratorDate,
      'debet': debet,
      'kredit': kredit
    };
  }

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
        json['id'] as int,
        json['registrator'] as String,
        json['date'] as String,
        json['debet'] as double,
        json['kredet'] as double);
  }
}
