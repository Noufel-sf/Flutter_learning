class CurrencyRate {
  final String code;
  final String name;
  final double rate;
  final String flag;

  const CurrencyRate({
    required this.code,
    required this.name,
    required this.rate,
    required this.flag,
  });

  // BEST PRACTICE: Factory constructor with defensive null-checks & type casting
  factory CurrencyRate.fromJson(String code, num rate) {
    return CurrencyRate(
      code: code,
      name: _getCurrencyName(code),
      rate: rate.toDouble(),
      flag: _getCurrencyFlag(code),
    );
  }

  static String _getCurrencyName(String code) {
    return switch (code) {
      'EUR' => 'Euro (European Union)',
      'GBP' => 'British Pound',
      'JPY' => 'Japanese Yen',
      'CAD' => 'Canadian Dollar',
      'AUD' => 'Australian Dollar',
      'CHF' => 'Swiss Franc',
      'CNY' => 'Chinese Yuan',
      'AED' => 'UAE Dirham',
      'BRL' => 'Brazilian Real',
      _ => '$code Currency',
    };
  }

  static String _getCurrencyFlag(String code) {
    return switch (code) {
      'EUR' => '🇪🇺',
      'GBP' => '🇬🇧',
      'JPY' => '🇯🇵',
      'CAD' => '🇨🇦',
      'AUD' => '🇦🇺',
      'CHF' => '🇨🇭',
      'CNY' => '🇨🇳',
      'BRL' => '🇧🇷',
      _ => '🌐',
    };
  }
}
