class PartnersModel {
  PartnersModel({
    required this.id,
    required this.name,
    required this.contactInfo,
    required this.company,
    required this.type,
  });

  final int id;
  final String name;
  final String contactInfo;
  final int company;
  final int type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'contact_info': contactInfo,
      'company': company,
      'type': type,
    };
  }

  factory PartnersModel.fromMap(Map<String, dynamic> map) {
    return PartnersModel(
      id: map['id'] as int,
      name: map['name'] as String,
      contactInfo: map['contact_info'] as String,
      company: map['company'] as int,
      type: map['type'] as int,
    );
  }
}
