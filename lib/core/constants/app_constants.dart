/// ═══════════════════════════════════════════════════════════
/// App Constants
/// ثوابت التطبيق
/// ═══════════════════════════════════════════════════════════
library;

class AppConstants {
  // Database
  static const String databaseName = 'metatrader_clone.db';
  static const int databaseVersion = 1;
  
  // Cache
  static const int maxCachedCandles = 5000;
  static const Duration cacheValidity = Duration(hours: 1);
  
  // Trading
  static const double minLotSize = 0.01;
  static const double maxLotSize = 100.0;
  static const int defaultLeverage = 100;
  
  // Chart
  static const int defaultCandleCount = 500;
  static const int maxVisibleCandles = 100;
  
  // Risk Management
  static const double defaultRiskPercentage = 2.0;
  static const double maxRiskPercentage = 10.0;
}
