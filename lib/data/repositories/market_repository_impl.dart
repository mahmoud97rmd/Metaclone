import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../core/constants/timeframe_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/candle.dart';
import '../../domain/entities/tick.dart';
import '../../domain/repositories/market_repository.dart';
import '../datasources/local/cache/candle_cache_manager.dart';
import '../datasources/remote/oanda_api_service.dart';
import '../datasources/remote/oanda_websocket_client.dart';

class MarketRepositoryImpl implements MarketRepository {
  final OandaApiService apiService;
  final OandaWebSocketClient webSocketClient;
  final CandleCacheManager cacheManager;
  final NetworkInfo networkInfo;
  final Logger logger;

  MarketRepositoryImpl({
    required this.apiService,
    required this.webSocketClient,
    required this.cacheManager,
    required this.networkInfo,
    required this.logger,
  });

  @override
  Future<Either<Failure, List<Candle>>> getHistoricalCandles({
    required String instrument,
    required Timeframe timeframe,
    int? count,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      // محاولة تحميل من الـ cache أولاً
      final cachedCandles = cacheManager.loadCandles(
        instrument,
        timeframe.code,
      );

      if (cachedCandles.isNotEmpty) {
        logger.d('Loaded ${cachedCandles.length} candles from cache');
        return Right(cachedCandles);
      }

      // التحقق من الاتصال
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }

      // جلب من API
      final response = await apiService.getCandles(
        instrument: instrument,
        granularity: timeframe.code,
        count: count,
        from: from?.toIso8601String(),
        to: to?.toIso8601String(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final candlesJson = data['candles'] as List<dynamic>;

        final candles = candlesJson.map((json) {
          final candleData = json as Map<String, dynamic>;
          final mid = candleData['mid'] as Map<String, dynamic>;

          return Candle(
            time: DateTime.parse(candleData['time'] as String),
            open: double.parse(mid['o'].toString()),
            high: double.parse(mid['h'].toString()),
            low: double.parse(mid['l'].toString()),
            close: double.parse(mid['c'].toString()),
            volume: double.parse(candleData['volume']?.toString() ?? '0'),
            isComplete: candleData['complete'] as bool? ?? true,
            instrument: instrument,
          );
        }).toList();

        // حفظ في الـ cache
        await cacheManager.saveCandles(instrument, timeframe.code, candles);

        logger.i('Fetched ${candles.length} candles for $instrument');
        return Right(candles);
      } else {
        return Left(ServerFailure(
          message: 'Failed to fetch candles',
          statusCode: response.statusCode,
        ));
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      logger.e('Error fetching candles', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, Tick>> subscribeToLivePrices({
    required List<String> instruments,
  }) {
    try {
      final tickStream = webSocketClient.connect(instruments);

      return tickStream.map((tick) => Right<Failure, Tick>(tick)).handleError(
        (error) {
          logger.e('Error in live price stream', error: error);
          return Left<Failure, Tick>(
            NetworkFailure(message: error.toString()),
          );
        },
      );
    } catch (e) {
      logger.e('Error subscribing to live prices', error: e);
      return Stream.value(
        Left(NetworkFailure(message: e.toString())),
      );
    }
  }

  @override
  Future<void> unsubscribeFromLivePrices() async {
    try {
      webSocketClient.disconnect();
      logger.i('Unsubscribed from live prices');
    } catch (e) {
      logger.e('Error unsubscribing from live prices', error: e);
    }
  }

  @override
  Future<Either<Failure, Tick>> getCurrentPrice({
    required String instrument,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }

      final response = await apiService.getCurrentPrice(instrument);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final prices = data['prices'] as List<dynamic>;

        if (prices.isNotEmpty) {
          final priceData = prices[0] as Map<String, dynamic>;
          final bids = priceData['bids'] as List<dynamic>;
          final asks = priceData['asks'] as List<dynamic>;

          final tick = Tick(
            instrument: instrument,
            time: DateTime.parse(priceData['time'] as String),
            bid: double.parse(bids[0]['price'].toString()),
            ask: double.parse(asks[0]['price'].toString()),
          );

          return Right(tick);
        }
      }

      return Left(ServerFailure(
        message: 'Failed to get current price',
        statusCode: response.statusCode,
      ));
    } catch (e) {
      logger.e('Error getting current price', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableInstruments() async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }

      final instruments = [
        'EUR_USD',
        'GBP_USD',
        'USD_JPY',
        'AUD_USD',
        'USD_CAD',
        'XAU_USD',
        'XAG_USD',
      ];

      return Right(instruments);
    } catch (e) {
      logger.e('Error getting instruments', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
