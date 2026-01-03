import 'dart:async';
import 'package:logger/logger.dart';

import '../../../domain/entities/candle.dart';
import '../indicators/indicator_engine.dart';

class StrategyEngine {
  final Logger logger;
  final IndicatorEngine indicatorEngine;
  StreamSubscription<dynamic>? _subscription;

  StrategyEngine({
    required this.logger,
    required this.indicatorEngine,
  });

  Future<Map<String, dynamic>?> generateSignal({
    required List<Candle> candles,
    required double currentPrice,
  }) async {
    if (candles.length < 50) {
      return null;
    }

    try {
      // حساب المؤشرات
      final ema20Values = indicatorEngine.calculateEMA(
        candles: candles,
        period: 20,
      );
      
      final ema50Values = indicatorEngine.calculateEMA(
        candles: candles,
        period: 50,
      );
      
      final rsiValues = indicatorEngine.calculateRSI(
        candles: candles,
        period: 14,
      );

      if (ema20Values.isEmpty || ema50Values.isEmpty || rsiValues.isEmpty) {
        return null;
      }

      final currentEma20 = ema20Values.last.value;
      final currentEma50 = ema50Values.last.value;
      final currentRsi = rsiValues.last.value;

      // إشارة شراء
      if (currentEma20 > currentEma50 && currentRsi < 70) {
        return {
          'type': 'BUY',
          'lotSize': 0.1,
          'stopLoss': currentPrice - 50,
          'takeProfit': currentPrice + 100,
        };
      }

      // إشارة بيع
      if (currentEma20 < currentEma50 && currentRsi > 30) {
        return {
          'type': 'SELL',
          'lotSize': 0.1,
          'stopLoss': currentPrice + 50,
          'takeProfit': currentPrice - 100,
        };
      }

      return null;
    } catch (e) {
      logger.e('Error generating signal', error: e);
      return null;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
