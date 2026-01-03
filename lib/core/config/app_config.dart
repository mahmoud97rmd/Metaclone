import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Private constructor
  AppConfig._();

  // Singleton instance
  static final AppConfig instance = AppConfig._();

  // Initialize dotenv
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  // OANDA Configuration
  String get environment => dotenv.get('OANDA_ENVIRONMENT', fallback: 'practice');
  bool get isLive => environment == 'live';
  bool get isPractice => environment == 'practice';

  // Practice Account
  String get practiceToken => dotenv.get('OANDA_PRACTICE_TOKEN', fallback: '');
  String get practiceAccountId => dotenv.get('OANDA_PRACTICE_ACCOUNT_ID', fallback: '');

  // Live Account
  String get liveToken => dotenv.get('OANDA_LIVE_TOKEN', fallback: '');
  String get liveAccountId => dotenv.get('OANDA_LIVE_ACCOUNT_ID', fallback: '');

  // Current Active Configuration
  String get token => isLive ? liveToken : practiceToken;
  String get accountId => isLive ? liveAccountId : practiceAccountId;

  // API Base URLs
  String get baseUrl => isLive 
      ? 'https://api-fxtrade.oanda.com'
      : 'https://api-fxpractice.oanda.com';

  String get streamUrl => isLive
      ? 'https://stream-fxtrade.oanda.com'
      : 'https://stream-fxpractice.oanda.com';

  // Validation
  bool get isConfigured {
    if (isPractice) {
      return practiceToken.isNotEmpty && practiceAccountId.isNotEmpty;
    } else {
      return liveToken.isNotEmpty && liveAccountId.isNotEmpty;
    }
  }

  // Debug Info
  Map<String, dynamic> get debugInfo => {
    'environment': environment,
    'isLive': isLive,
    'isPractice': isPractice,
    'baseUrl': baseUrl,
    'streamUrl': streamUrl,
    'hasToken': token.isNotEmpty,
    'hasAccountId': accountId.isNotEmpty,
    'isConfigured': isConfigured,
  };
}
