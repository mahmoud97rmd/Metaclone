/// ═══════════════════════════════════════════════════════════
/// Stochastic Oscillator Calculator
/// مؤشر ستوكاستيك
/// ═══════════════════════════════════════════════════════════
library;

import 'dart:collection';
import 'dart:math';
import '../../../domain/entities/candle.dart';
import '../../../domain/entities/indicator.dart';
import 'base_indicator_calculator.dart';

class StochasticCalculator
    extends BaseIndicatorCalculator<MultiLineIndicatorValue> {
  final int kPeriod; // %K period (عادة 14)
  final int dPeriod; // %D period (عادة 3)
  final int slowing; // Slowing period (عادة 3)
  final String indicatorId;

  // Buffers للحساب التدريجي
  final Queue<double> _highValues = Queue();
  final Queue<double> _lowValues = Queue();
  final Queue<double> _closeValues = Queue();
  final Queue<double> _kValues = Queue();

  StochasticCalculator({
    required this.kPeriod,
    required this.dPeriod,
    required this.slowing,
    required this.indicatorId,
  });

  @override
  bool validateParameters() {
    return kPeriod > 0 && dPeriod > 0 && slowing > 0;
  }

  @override
  List<MultiLineIndicatorValue> calculate(List<Candle> candles) {
    if (!validateParameters() || candles.length < kPeriod) {
      return [];
    }

    final results = <MultiLineIndicatorValue>[];

    for (int i = 0; i < candles.length; i++) {
      _highValues.add(candles[i].high);
      _lowValues.add(candles[i].low);
      _closeValues.add(candles[i].close);

      // الحفاظ على حجم النافذة
      if (_highValues.length > kPeriod) {
        _highValues.removeFirst();
        _lowValues.removeFirst();
        _closeValues.removeFirst();
      }

      if (_highValues.length == kPeriod) {
        // حساب %K
        final highestHigh = _highValues.reduce(max);
        final lowestLow = _lowValues.reduce(min);
        final currentClose = _closeValues.last;

        final k = lowestLow != highestHigh
            ? ((currentClose - lowestLow) / (highestHigh - lowestLow)) * 100
            : 50.0;

        _kValues.add(k);

        // الحفاظ على حجم buffer %K
        if (_kValues.length > dPeriod) {
          _kValues.removeFirst();
        }

        // حساب %D (SMA of %K)
        if (_kValues.length == dPeriod) {
          final d = _kValues.reduce((a, b) => a + b) / dPeriod;

          results.add(MultiLineIndicatorValue(
            time: candles[i].time,
            values: {
              'k': k,
              'd': d,
            },
            indicatorId: indicatorId,
          ));
        }
      }
    }

    return results;
  }

  @override
  MultiLineIndicatorValue? calculateSingle(
    Candle candle,
    List<Candle> previousCandles,
  ) {
    _highValues.add(candle.high);
    _lowValues.add(candle.low);
    _closeValues.add(candle.close);

    if (_highValues.length > kPeriod) {
      _highValues.removeFirst();
      _lowValues.removeFirst();
      _closeValues.removeFirst();
    }

    if (_highValues.length == kPeriod) {
      final highestHigh = _highValues.reduce(max);
      final lowestLow = _lowValues.reduce(min);
      final currentClose = _closeValues.last;

      final k = lowestLow != highestHigh
          ? ((currentClose - lowestLow) / (highestHigh - lowestLow)) * 100
          : 50.0;

      _kValues.add(k);

      if (_kValues.length > dPeriod) {
        _kValues.removeFirst();
      }

      if (_kValues.length == dPeriod) {
        final d = _kValues.reduce((a, b) => a + b) / dPeriod;

        return MultiLineIndicatorValue(
          time: candle.time,
          values: {
            'k': k,
            'd': d,
          },
          indicatorId: indicatorId,
        );
      }
    }

    return null;
  }

  void reset() {
    _highValues.clear();
    _lowValues.clear();
    _closeValues.clear();
    _kValues.clear();
  }
}
