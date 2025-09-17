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
