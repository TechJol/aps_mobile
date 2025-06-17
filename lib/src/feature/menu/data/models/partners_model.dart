class PartnersModel {
  PartnersModel({
    this.id,
    required this.name,
    required this.contactInfo,
    this.company,
    required this.type,
  });

  final int? id;
  final String name;
  final String? contactInfo;
  final int? company;
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
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      contactInfo:
          map['contact_info'] != null ? map['contact_info'] as String : null,
      company: map['company'] != null ? map['company'] as int : null,
      type: map['type'] as int,
    );
  }
}
