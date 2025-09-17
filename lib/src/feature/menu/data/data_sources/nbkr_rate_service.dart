// ignore_for_file: unintended_html_in_doc_comment

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Получает официальный курс НБКР и кэширует его на текущие сутки.
/// Возвращает Map<ISO, ratePerUnit>, где rate — за 1 единицу валюты.
/// KGS = 1.0 по умолчанию.
class NbkrRatesService {
  final Dio _dio;
  NbkrRatesService(this._dio);

  static const _cacheRatesKey = 'nbkr_rates_json';
  static const _cacheDateKey = 'nbkr_rates_date'; // 'yyyy-MM-dd'

  Future<Map<String, double>> fetchRates({DateTime? date}) async {
    // 1) Кэш на сутки
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
    final cachedDate = prefs.getString(_cacheDateKey);
    final cachedJson = prefs.getString(_cacheRatesKey);

    if (cachedDate == today && cachedJson != null) {
      final Map<String, dynamic> m = jsonDecode(cachedJson);
      return m.map((k, v) => MapEntry(k, (v as num).toDouble()));
    }

    // 2) Сеть
    // У НБКР есть ежедневная XML-лента. Параметр даты обычно опционален.
    // Пример: https://www.nbkr.kg/XML/daily.xml или ?date=dd.MM.yyyy
    final q = DateFormat('dd.MM.yyyy').format(date ?? DateTime.now());
    final url = 'https://www.nbkr.kg/XML/daily.xml?date=$q';

    final res = await _dio.get<String>(
      url,
      options: Options(responseType: ResponseType.plain),
    );

    final doc = XmlDocument.parse(res.data ?? '');
    final Map<String, double> rates = {'KGS': 1.0};

    for (final c in doc.findAllElements('Currency')) {
      final code = c.getAttribute('ISOCode') ?? c.getAttribute('ISO') ?? '';
      if (code.isEmpty) continue;

      final nominalStr = c.getElement('Nominal')?.text.trim() ?? '1';
      final valueStr =
          c.getElement('Value')?.text.trim() ??
          c.getElement('Rate')?.text.trim() ??
          '0';

      // У НБКР бывает запятая как разделитель
      final nominal = double.tryParse(nominalStr.replaceAll(',', '.')) ?? 1.0;
      final value = double.tryParse(valueStr.replaceAll(',', '.')) ?? 0.0;

      if (nominal > 0 && value > 0) {
        rates[code.toUpperCase()] = value / nominal; // курс за 1 ед.
      }
    }

    // 3) Сохраняем кэш на сегодня
    await prefs.setString(_cacheDateKey, today);
    await prefs.setString(_cacheRatesKey, jsonEncode(rates));

    return rates;
  }
}
