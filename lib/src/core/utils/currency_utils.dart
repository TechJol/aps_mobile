import 'package:intl/intl.dart';

const Map<String, String> _prefixCurrencySymbols = {
  'USD': '\$',
  'EUR': '€',
  'RUB': '₽',
};

const Map<String, String> _suffixCurrencySymbols = {'KGS': 'с'};

String currencySymbol(String? currencyCode) {
  final code = currencyCode?.toUpperCase() ?? 'KGS';
  if (_prefixCurrencySymbols.containsKey(code)) {
    return _prefixCurrencySymbols[code]!;
  }
  if (_suffixCurrencySymbols.containsKey(code)) {
    return _suffixCurrencySymbols[code]!;
  }
  return code;
}

String formatAmountWithCurrency(String? amount, String? currencyCode) {
  final value = (amount ?? '').trim();
  if (value.isEmpty) return value;
  final code = currencyCode?.toUpperCase() ?? 'KGS';

  if (_prefixCurrencySymbols.containsKey(code)) {
    return '${_prefixCurrencySymbols[code]}$value';
  }
  if (_suffixCurrencySymbols.containsKey(code)) {
    return '$value ${_suffixCurrencySymbols[code]}';
  }
  final symbol = currencySymbol(code);
  return '$value $symbol';
}

String formatNumericAmountWithCurrency(
  double value,
  String? currencyCode, {
  NumberFormat? formatter,
}) {
  final code = currencyCode?.toUpperCase() ?? 'KGS';
  final numberFormatter = formatter ??
      NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 2);
  final formattedNumber = numberFormatter.format(value.abs());
  final sign = value < 0 ? '-' : '';

  if (_prefixCurrencySymbols.containsKey(code)) {
    return '$sign${_prefixCurrencySymbols[code]}$formattedNumber';
  }

  if (_suffixCurrencySymbols.containsKey(code)) {
    return '$sign$formattedNumber ${_suffixCurrencySymbols[code]}';
  }

  return '$sign$formattedNumber $code';
}
