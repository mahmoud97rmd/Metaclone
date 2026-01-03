/// ═══════════════════════════════════════════════════════════
/// Instrument Constants - الأدوات المالية المتاحة
/// ═══════════════════════════════════════════════════════════
library;

class InstrumentConstants {
  InstrumentConstants._();

  // ════════════════════════════════════════════════════════════
  // Major Forex Pairs
  // ════════════════════════════════════════════════════════════
  
  static const String eurUsd = 'EUR_USD';
  static const String gbpUsd = 'GBP_USD';
  static const String usdJpy = 'USD_JPY';
  static const String usdChf = 'USD_CHF';
  static const String audusd = 'AUD_USD';
  static const String usdCad = 'USD_CAD';
  static const String nzdUsd = 'NZD_USD';
  
  // ════════════════════════════════════════════════════════════
  // Precious Metals
  // ════════════════════════════════════════════════════════════
  
  static const String xauUsd = 'XAU_USD'; // الذهب
  static const String xagUsd = 'XAG_USD'; // الفضة
  
  // ════════════════════════════════════════════════════════════
  // Oil
  // ════════════════════════════════════════════════════════════
  
  static const String wtiUsd = 'WTICO_USD'; // النفط الأمريكي
  static const String brentUsd = 'BCO_USD'; // النفط البريطاني
  
  // ════════════════════════════════════════════════════════════
  // Default Instruments List
  // ════════════════════════════════════════════════════════════
  
  static const List<String> defaultInstruments = [
    xauUsd,
    eurUsd,
    gbpUsd,
    usdJpy,
    xagUsd,
  ];
  
  // ════════════════════════════════════════════════════════════
  // Instrument Display Names (Arabic)
  // ════════════════════════════════════════════════════════════
  
  static const Map<String, String> instrumentDisplayNames = {
    xauUsd: 'الذهب مقابل الدولار',
    eurUsd: 'اليورو مقابل الدولار',
    gbpUsd: 'الجنيه الإسترليني مقابل الدولار',
    usdJpy: 'الدولار مقابل الين الياباني',
    xagUsd: 'الفضة مقابل الدولار',
    wtiUsd: 'النفط الأمريكي',
    brentUsd: 'النفط البريطاني',
  };
  
  /// Get display name for instrument
  static String getDisplayName(String instrument) {
    return instrumentDisplayNames[instrument] ?? instrument;
  }
  
  /// Get pip value (number of decimal places)
  static int getPipPrecision(String instrument) {
    if (instrument.contains('JPY')) return 3;
    if (instrument.startsWith('XAU')) return 2;
    if (instrument.startsWith('XAG')) return 4;
    return 5; // Default for major pairs
  }
}
