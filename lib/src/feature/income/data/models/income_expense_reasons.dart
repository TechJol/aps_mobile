class IncomeExpenseReasons {
  final int id;
  final String name;
  final String type;
  final String company;

  IncomeExpenseReasons({
    required this.id,
    required this.name,
    required this.type,
    required this.company,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'company': company,
    };
  }

  factory IncomeExpenseReasons.fromMap(Map<String, dynamic> map) {
    return IncomeExpenseReasons(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
      company: map['company'] as String,
    );
  }
}
