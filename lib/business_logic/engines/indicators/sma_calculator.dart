/// ═══════════════════════════════════════════════════════════
/// SMA (Simple Moving Average) Calculator
/// المتوسط المتحرك البسيط
/// ═══════════════════════════════════════════════════════════

import 'dart:collection';
import '../../../domain/entities/candle.dart';
import '../../../domain/entities/indicator.dart';
import 'base_indicator_calculator.dart';

class SMACalculator extends BaseIndicatorCalculator<IndicatorValue> {
  final int period;
  final String indicatorId;

  // Circular buffer للقيم الأخيرة
  final Queue<double> _values = Queue();
  double _sum = 0;

  SMACalculator({
    required this.period,
    required this.indicatorId,
  });

  @override
  bool validateParameters() {
    return period > 0;
  }

  @override
  List<IndicatorValue> calculate(List<Candle> candles) {
    if (!validateParameters() || candles.length < period) {
      return [];
    }

    final results = <IndicatorValue>[];

    for (int i = 0; i < candles.length; i++) {
      _values.add(candles[i].close);
      _sum += candles[i].close;

      if (_values.length > period) {
        _sum -= _values.removeFirst();
      }

      if (_values.length == period) {
        final sma = _sum / period;
        results.add(IndicatorValue(
          time: candles[i].time,
          value: sma,
          indicatorId: indicatorId,
        ));
      }
    }

    return results;
  }

  @override
  IndicatorValue? calculateSingle(Candle candle, List<Candle> previousCandles) {
    _values.add(candle.close);
    _sum += candle.close;

    if (_values.length > period) {
      _sum -= _values.removeFirst();
    }

    if (_values.length == period) {
      final sma = _sum / period;
      return IndicatorValue(
        time: candle.time,
        value: sma,
        indicatorId: indicatorId,
      );
    }

    return null;
  }

  void reset() {
    _values.clear();
    _sum = 0;
  }
}
