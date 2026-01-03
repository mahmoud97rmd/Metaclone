import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/network_info.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/local/simple_storage.dart';
import '../../data/datasources/local/cache/candle_cache_manager.dart';
import '../../data/datasources/remote/oanda_api_service.dart';
import '../../data/datasources/remote/oanda_websocket_client.dart';
import '../../data/repositories/market_repository_impl.dart';
import '../../data/repositories/trading_repository_impl.dart';
import '../../data/repositories/indicator_repository_impl.dart';
import '../../domain/repositories/market_repository.dart';
import '../../domain/repositories/trading_repository.dart';
import '../../domain/repositories/indicator_repository.dart';
import '../../domain/usecases/market/get_historical_candles.dart';
import '../../domain/usecases/market/subscribe_to_live_prices.dart';
import '../../domain/usecases/market/get_current_price.dart';
import '../../domain/usecases/trading/execute_trade.dart';
import '../../domain/usecases/trading/close_trade.dart';
import '../../domain/usecases/trading/modify_trade.dart';
import '../../domain/usecases/trading/get_account_info.dart';
import '../../domain/usecases/indicators/calculate_ema.dart';
import '../../domain/usecases/indicators/calculate_sma.dart';
import '../../domain/usecases/indicators/calculate_rsi.dart';
import '../../domain/usecases/indicators/calculate_stochastic.dart';
import '../../business_logic/engines/indicators/indicator_engine.dart';
import '../../business_logic/engines/trading/position_manager.dart';
import '../../business_logic/engines/strategy/strategy_engine.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // External
  getIt.registerLazySingleton<Logger>(
    () => Logger(printer: PrettyPrinter(methodCount: 0, colors: true)),
  );

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      secureStorage: getIt<FlutterSecureStorage>(),
      isLive: false,
    ),
  );

  // Data Sources
  getIt.registerLazySingleton<SimpleStorage>(
    () => SimpleStorage(
      prefs: getIt<SharedPreferences>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<CandleCacheManager>(
    () => CandleCacheManager(
      storage: getIt<SimpleStorage>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<OandaApiService>(
    () => OandaApiService(
      dio: getIt<DioClient>().dio,
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<OandaWebSocketClient>(
    () => OandaWebSocketClient(
      secureStorage: getIt<FlutterSecureStorage>(),
      logger: getIt<Logger>(),
      isLive: false,
    ),
  );

  // Business Logic Engines
  getIt.registerLazySingleton<IndicatorEngine>(
    () => IndicatorEngine(logger: getIt<Logger>()),
  );

  getIt.registerLazySingleton<PositionManager>(
    () => PositionManager(logger: getIt<Logger>()),
  );

  getIt.registerLazySingleton<StrategyEngine>(
    () => StrategyEngine(
      logger: getIt<Logger>(),
      indicatorEngine: getIt<IndicatorEngine>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(
      apiService: getIt<OandaApiService>(),
      webSocketClient: getIt<OandaWebSocketClient>(),
      cacheManager: getIt<CandleCacheManager>(),
      networkInfo: getIt<NetworkInfo>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<TradingRepository>(
    () => TradingRepositoryImpl(
      apiService: getIt<OandaApiService>(),
      storage: getIt<SimpleStorage>(),
      networkInfo: getIt<NetworkInfo>(),
      logger: getIt<Logger>(),
    ),
  );

  getIt.registerLazySingleton<IndicatorRepository>(
    () => IndicatorRepositoryImpl(
      logger: getIt<Logger>(),
      indicatorEngine: getIt<IndicatorEngine>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetHistoricalCandles(getIt()));
  getIt.registerLazySingleton(() => SubscribeToLivePrices(getIt()));
  getIt.registerLazySingleton(() => GetCurrentPrice(getIt()));
  getIt.registerLazySingleton(() => ExecuteTrade(getIt()));
  getIt.registerLazySingleton(() => CloseTrade(getIt()));
  getIt.registerLazySingleton(() => ModifyTrade(getIt()));
  getIt.registerLazySingleton(() => GetAccountInfo(getIt()));
  getIt.registerLazySingleton(() => CalculateEMA(getIt()));
  getIt.registerLazySingleton(() => CalculateSMA(getIt()));
  getIt.registerLazySingleton(() => CalculateRSI(getIt()));
  getIt.registerLazySingleton(() => CalculateStochastic(getIt()));

  getIt<Logger>().i('✅ All dependencies registered successfully');
}
