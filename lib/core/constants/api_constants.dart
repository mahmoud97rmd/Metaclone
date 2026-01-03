/// ═══════════════════════════════════════════════════════════
/// API Constants - جميع الثوابت المتعلقة بـ OANDA API
/// ═══════════════════════════════════════════════════════════

class ApiConstants {
  ApiConstants._();

  // ════════════════════════════════════════════════════════════
  // Base URLs
  // ════════════════════════════════════════════════════════════
  
  /// Practice Environment (Demo Account)
  static const String practiceBaseUrl = 'https://api-fxpractice.oanda.com';
  
  /// Live Environment (Real Account)
  static const String liveBaseUrl = 'https://api-fxtrade.oanda.com';
  
  /// Streaming Base URL (Practice)
  static const String practiceStreamUrl = 'https://stream-fxpractice.oanda.com';
  
  /// Streaming Base URL (Live)
  static const String liveStreamUrl = 'https://stream-fxtrade.oanda.com';
  
  // ════════════════════════════════════════════════════════════
  // API Version
  // ════════════════════════════════════════════════════════════
  
  static const String apiVersion = 'v3';
  
  // ════════════════════════════════════════════════════════════
  // Endpoints
  // ════════════════════════════════════════════════════════════
  
  /// Get account details
  static const String accountsEndpoint = '/$apiVersion/accounts';
  
  /// Get account summary
  static String accountSummary(String accountId) => 
      '/$apiVersion/accounts/$accountId/summary';
  
  /// Get instruments
  static String instruments(String accountId) => 
      '/$apiVersion/accounts/$accountId/instruments';
  
  /// Get candles (Historical Data)
  static String candles(String instrument) => 
      '/$apiVersion/instruments/$instrument/candles';
  
  /// Pricing Stream (Real-time data)
  static String pricingStream(String accountId) => 
      '/$apiVersion/accounts/$accountId/pricing/stream';
  
  /// Get current prices
  static String pricing(String accountId) => 
      '/$apiVersion/accounts/$accountId/pricing';
  
  /// Place order
  static String orders(String accountId) => 
      '/$apiVersion/accounts/$accountId/orders';
  
  /// Get open trades
  static String trades(String accountId) => 
      '/$apiVersion/accounts/$accountId/trades';
  
  /// Close specific trade
  static String closeTrade(String accountId, String tradeId) => 
      '/$apiVersion/accounts/$accountId/trades/$tradeId/close';
  
  // ════════════════════════════════════════════════════════════
  // Headers
  // ════════════════════════════════════════════════════════════
  
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptDatetimeFormatHeader = 'Accept-Datetime-Format';
  
  // ════════════════════════════════════════════════════════════
  // Timeouts
  // ════════════════════════════════════════════════════════════
  
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // ════════════════════════════════════════════════════════════
  // Rate Limiting
  // ════════════════════════════════════════════════════════════
  
  /// Maximum requests per second (OANDA limit)
  static const int maxRequestsPerSecond = 120;
  
  /// Delay between requests to avoid rate limiting
  static const Duration requestDelay = Duration(milliseconds: 10);
}
