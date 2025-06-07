import 'package:aps_mobile/src/feature/feature.dart';

class IncomeAndComeoutModel extends IncomeAndComeoutEntity {
  IncomeAndComeoutModel({
    required super.date,
    required super.account,
    required super.summa,
    required super.article,
    required super.description,
  });

  factory IncomeAndComeoutModel.fromJson(Map<String, dynamic> json) {
    return IncomeAndComeoutModel(
      date: json['date'],
      account: json['account'],
      summa: json['summa'],
      article: json['article'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'account': account,
    'summa': summa,
    'article': article,
    'description': description,
  };
}
