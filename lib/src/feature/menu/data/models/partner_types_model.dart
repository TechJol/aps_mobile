class PartnerTypesModel {
  PartnerTypesModel({this.id, required this.name, this.company});

  final int? id;
  final String name;
  final int? company;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'company': company};
  }

  factory PartnerTypesModel.fromMap(Map<String, dynamic> map) {
    return PartnerTypesModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      company: map['company'] != null ? map['company'] as int : null,
    );
  }
}
