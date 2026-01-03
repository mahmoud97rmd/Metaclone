import 'package:logger/logger.dart';
import '../simple_storage.dart';
import '../../../../domain/entities/candle.dart';

class CandleCacheManager {
  final SimpleStorage storage;
  final Logger logger;

  CandleCacheManager({
    required this.storage,
    required this.logger,
  });

  Future<void> saveCandles(
    String instrument,
    String timeframe,
    List<Candle> candles,
  ) async {
    try {
      final key = _getCacheKey(instrument, timeframe);
      final data = candles.map((c) => _candleToMap(c)).toList();
      
      await storage.saveList(key, data);
      logger.d('Cached ${candles.length} candles for $instrument $timeframe');
    } catch (e) {
      logger.e('Error caching candles', error: e);
    }
  }

  List<Candle> loadCandles(String instrument, String timeframe) {
    try {
      final key = _getCacheKey(instrument, timeframe);
      final data = storage.loadList(key);
      
      return data.map((m) => _mapToCandle(m)).toList();
    } catch (e) {
      logger.e('Error loading cached candles', error: e);
      return [];
    }
  }

  Future<void> clearCache() async {
    await storage.clear();
    logger.d('Cache cleared');
  }

  String _getCacheKey(String instrument, String timeframe) {
    return 'candles_${instrument}_$timeframe';
  }

  Map<String, dynamic> _candleToMap(Candle candle) {
    return {
      'time': candle.time.toIso8601String(),
      'open': candle.open,
      'high': candle.high,
      'low': candle.low,
      'close': candle.close,
      'volume': candle.volume,
      'isComplete': candle.isComplete,
      'instrument': candle.instrument,
    };
  }

  Candle _mapToCandle(Map<String, dynamic> map) {
    return Candle(
      time: DateTime.parse(map['time'] as String),
      open: (map['open'] as num).toDouble(),
      high: (map['high'] as num).toDouble(),
      low: (map['low'] as num).toDouble(),
      close: (map['close'] as num).toDouble(),
      volume: (map['volume'] as num?)?.toDouble() ?? 0.0,
      isComplete: map['isComplete'] as bool? ?? true,
      instrument: map['instrument'] as String? ?? '',
    );
  }
}
